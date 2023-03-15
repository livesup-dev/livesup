defmodule LiveSup.Queries.CommentQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Comment, TodoTask}
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  @doc """
  Get all comments by task
  """
  def by_task(%TodoTask{id: task_id}) do
    by_task(task_id)
  end

  def by_task(task_id) do
    base()
    |> where([c], c.task_id == ^task_id)
    |> order_by([comment], comment.inserted_at)
    |> Repo.all()
  end

  @doc """
  Get a comment
  """
  def get!(%Comment{id: comment_id}) do
    base()
    |> Repo.get!(comment_id)
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  @doc """
  Get a comment
  """
  def get(%Comment{id: comment_id}) do
    base()
    |> Repo.get(comment_id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  @doc """
  Creates a comment
  """
  def create(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update a comment
  """
  def update(model, attrs) do
    model
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def base, do: from(Comment, as: :comment, preload: [:task, :created_by])
end
