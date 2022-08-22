defmodule LiveSup.Queries.TaskQuery do
  import Ecto.Query

  alias LiveSup.Schemas.Todo
  alias LiveSup.Schemas.TodoTask
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  def by_todo(%Todo{id: todo_id}) do
    base()
    |> where([p], p.todo_id == ^todo_id)
    |> order_by([todo], todo.description)
    |> Repo.all()
  end

  def by_todo(todo_id) do
    base()
    |> where([p], p.todo_id == ^todo_id)
    |> Repo.all()
  end

  def get!(%TodoTask{id: todo_id}) do
    base()
    |> Repo.get!(todo_id)
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_with_todo(id) do
    base()
    |> join(:inner, [d], p in Todo, on: d.todo_id == p.id)
    |> Repo.get(id)
  end

  def get(%TodoTask{id: todo_id}) do
    base()
    |> Repo.get(todo_id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def create(attrs) do
    %TodoTask{}
    |> TodoTask.create_changeset(attrs)
    |> Repo.insert()
  end

  def create!(attrs) do
    %TodoTask{}
    |> TodoTask.create_changeset(attrs)
    |> Repo.insert!()
  end

  def update(%TodoTask{} = model, attrs) do
    model
    |> TodoTask.update_changeset(attrs)
    |> Repo.update()
  end

  def delete(%TodoTask{} = model) do
    model
    |> Repo.delete()
  end

  def delete_all(%Todo{id: todo_id}) do
    query =
      from(
        d in TodoTask,
        where: d.todo_id == ^todo_id
      )

    query
    |> Repo.delete_all()
  end

  def delete_all(todo_id) when is_binary(todo_id) do
    %Todo{id: todo_id}
    |> delete_all
  end

  def base, do: from(TodoTask, as: :todo, preload: [:todo, :assigned_to, :created_by])
end
