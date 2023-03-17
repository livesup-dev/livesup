defmodule LiveSup.Core.Todos do
  @moduledoc """
  The Todos context.
  """

  alias LiveSup.Schemas.{Todo, Project, TodoDatasource, DatasourceInstance}
  alias LiveSup.Queries.{TodoQuery, TaskQuery, TodoDatasourceQuery}
  alias LiveSup.Helpers.StringHelper
  alias LiveSup.Core.Users

  @doc """
  Returns the list of todos.

  ## Examples

      iex> all()
      [%Todo{}, ...]

  """
  defdelegate by_project(project, filter \\ %{}), to: TodoQuery
  defdelegate archive(todo), to: TodoQuery
  defdelegate create!(attrs), to: TodoQuery
  defdelegate upsert_datasource!(todo, data), to: TodoQuery

  def get(id) do
    id
    |> TodoQuery.get()
    |> found()
  end

  def get_with_project(id) do
    id
    |> TodoQuery.get_with_project()
    |> found()
  end

  def get_tasks(todo_id, filters \\ []) do
    todo_id
    |> TaskQuery.by_todo(filters)
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  defdelegate get!(id), to: TodoQuery

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Todo{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) when is_map(attrs) do
    attrs
    |> TodoQuery.create()
  end

  def create(%Project{id: project_id}, attrs \\ %{}) do
    attrs
    |> StringHelper.keys_to_strings()
    |> Enum.into(%{"project_id" => project_id})
    |> TodoQuery.create()
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Todo{} = todo, attrs) do
    todo
    |> TodoQuery.update(attrs)
  end

  def add_task(attrs) do
    case TaskQuery.create(attrs) do
      {:ok, task} -> {:ok, TaskQuery.get(task)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_task!(attrs) do
    TaskQuery.create!(attrs)
  end

  def upsert_task(attrs) do
    TaskQuery.upsert!(attrs)
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete(todo)
      {:ok, %Todo{}}

      iex> delete(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Todo{} = todo) do
    todo
    |> TodoQuery.delete()
  end

  def delete_all(%Project{} = project) do
    project
    |> TodoQuery.delete_all()
  end

  def run_datasource(%TodoDatasource{} = todo_datasource) do
    case todo_datasource
         |> build_context()
         |> do_run_datasource do
      {:ok, tasks} ->
        TodoDatasourceQuery.update(todo_datasource, %{last_run_at: DateTime.utc_now()})
        {:ok, tasks}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_context(%TodoDatasource{last_run_at: last_run_at} = todo_datasource) do
    %{
      todo_datasource: todo_datasource,
      last_run_at: last_run_at,
      run_from: last_run_at |> parse_last_run_date(),
      run_to: DateTime.utc_now() |> parse_last_run_date()
    }
  end

  defp parse_last_run_date(nil) do
    DateTime.utc_now()
    |> Timex.shift(months: -6)
    |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  defp parse_last_run_date(date) do
    date
    |> Timex.format!("{YYYY}-{0M}-{0D}")
  end

  def do_run_datasource(%{
        run_from: run_from,
        run_to: run_to,
        todo_datasource:
          %{
            todo: todo,
            datasource_instance:
              %DatasourceInstance{
                datasource: %{slug: "github-datasource"}
              } = datasource_instance
          } = todo_datasource
      }) do
    %{"owner" => owner, "repository" => repository, "token" => token} =
      todo_datasource
      |> TodoDatasource.get_settings([
        "owner",
        "repository",
        "token",
        "limit",
        "token"
      ])

    filter = "updated:#{run_from}..#{run_to}"

    case LiveSup.Core.Datasources.GithubDatasource.search_pull_requests(owner, repository,
           token: token,
           filter: filter
         ) do
      {:ok, pull_requests} ->
        pull_requests |> add_tasks_from_pull_requests(todo, datasource_instance)

      {:error, error} ->
        {:error, error}
    end
  end

  def add_tasks_from_pull_requests(pull_requests, todo, %{
        id: datasource_instance_id,
        datasource: %{slug: datasource_slug}
      }) do
    tasks =
      pull_requests
      |> Enum.map(fn pull_request ->
        %{
          title: pull_request[:title],
          description: pull_request[:body],
          todo_id: todo.id,
          tags: ["github", pull_request[:repo][:name]],
          external_identifier: pull_request[:id],
          external_metadata: pull_request,
          datasource_instance_id: datasource_instance_id,
          datasource_slug: datasource_slug,
          created_by_id: Users.get_default_system_account!().id,
          inserted_at: pull_request[:created_at],
          updated_at: pull_request[:updated_at],
          completed: pull_request[:merged] || pull_request[:closed]
        }
        |> upsert_task()
      end)

    {:ok, tasks}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
