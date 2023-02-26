defmodule LiveSup.Core.Todos do
  @moduledoc """
  The Todos context.
  """

  alias LiveSup.Schemas.{Todo, Project}
  alias LiveSup.Queries.{TodoQuery, TaskQuery}
  alias LiveSup.Helpers.StringHelper

  @doc """
  Returns the list of todos.

  ## Examples

      iex> all()
      [%Todo{}, ...]

  """
  defdelegate by_project(project, filter \\ %{}), to: TodoQuery
  defdelegate archive(todo), to: TodoQuery

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
