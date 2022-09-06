defmodule LiveSup.Core.Comments do
  @moduledoc """
  The Comments context.
  """

  alias LiveSup.Schemas.{Comment, TodoTask}
  alias LiveSup.Queries.CommentQuery

  @doc """
  Returns the list of comments by task.

  ## Examples

      iex> by_task(task)
      [%Comment{}, ...]

  """
  @spec by_task(TodoTask.t()) :: [Comment.t()]
  defdelegate by_task(task), to: CommentQuery
  defdelegate get!(id), to: CommentQuery

  @doc """
  Get a comment by id
  """
  @spec get(String.t()) :: Comment.t()
  def get(id) do
    id
    |> CommentQuery.get()
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  @doc """
  Creates a comment.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Todo{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) when is_map(attrs) do
    attrs
    |> CommentQuery.create()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update(task, %{field: new_value})
      {:ok, %Comment{}}

      iex> update(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Comment{} = comment, attrs) do
    comment
    |> CommentQuery.update(attrs)
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete(comment)
      {:ok, %Todo{}}

      iex> delete(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Comment{} = comment) do
    comment
    |> CommentQuery.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
