defmodule LiveSup.Queries.TodoQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Project, Todo}
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  def by_project(%Project{id: project_id}) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> order_by([todo], todo.name)
    |> Repo.all()
  end

  def by_project(project_id) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> Repo.all()
  end

  def get!(%Todo{id: todo_id}) do
    base()
    |> Repo.get!(todo_id)
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_with_project(id) do
    base()
    |> join(:inner, [d], p in Project, on: d.project_id == p.id)
    |> Repo.get(id)
  end

  def get(%Todo{id: todo_id}) do
    base()
    |> Repo.get(todo_id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def create(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
  end

  def update(model, attrs) do
    model
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def delete_all(%Project{id: project_id}) do
    query =
      from(
        d in Todo,
        where: d.project_id == ^project_id
      )

    query
    |> Repo.delete_all()
  end

  def base, do: from(Todo, as: :todo, preload: [:project])
end
