defmodule LiveSup.Core.Tasks do
  @moduledoc """
  The Todos context.
  """

  alias LiveSup.Schemas.{Todo, TodoTask, User}
  alias LiveSup.Queries.{TaskQuery, CommentQuery}
  alias LiveSup.Helpers.StringHelper

  @doc """
  Returns the list of todos.

  ## Examples

      iex> all()
      [%Todo{}, ...]

  """
  defdelegate by_todo(todo_id, filters \\ []), to: TaskQuery
  defdelegate get!(id), to: TaskQuery
  defdelegate complete!(id), to: TaskQuery
  defdelegate incomplete!(id), to: TaskQuery

  def get(id) do
    id
    |> TaskQuery.get()
    |> found()
  end

  def get_with_todo(id) do
    id
    |> TaskQuery.get_with_todo()
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  @doc """
  Creates a todo.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Todo{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) when is_map(attrs) do
    attrs
    |> TaskQuery.create()
  end

  def create(%Todo{id: todo_id}, attrs \\ %{}) do
    attrs
    |> StringHelper.keys_to_strings()
    |> Enum.into(%{"todo_id" => todo_id})
    |> TaskQuery.create()
  end

  @doc """
  Add comment to a task
  """
  @spec add_comment(
          LiveSup.Schemas.TodoTask.t(),
          LiveSup.Schemas.User.t(),
          String.t()
        ) :: {:ok, LiveSup.Schemas.Comment.t()}
  def add_comment(%TodoTask{id: task_id}, %User{id: user_id}, comment) do
    %{
      created_by_id: user_id,
      body: comment,
      task_id: task_id
    }
    |> CommentQuery.create()
  end

  @doc """
  Get a task with comments
  """
  @spec get_with_comments!(TodoTask.t()) :: TodoTask.t()
  def get_with_comments!(%TodoTask{id: task_id}) do
    # TODO: Please refactor
    base_query = TaskQuery.base(preload: [:todo, :assigned_to, :created_by, :comments])

    task_id
    |> TaskQuery.get!(base: base_query)
  end

  def get_comments(%TodoTask{id: task_id}) do
    task_id
    |> CommentQuery.by_task()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update(task, %{field: new_value})
      {:ok, %TodoTask{}}

      iex> update(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%TodoTask{} = task, attrs) do
    task
    |> TaskQuery.update(attrs)
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete(task)
      {:ok, %Todo{}}

      iex> delete(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%TodoTask{} = task) do
    task
    |> TaskQuery.delete()
  end

  def delete_all(%Todo{} = todo) do
    todo
    |> TaskQuery.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change(task)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change(%TodoTask{} = task, attrs \\ %{}) do
    TodoTask.update_changeset(task, attrs)
  end
end
