defmodule LiveSup.Queries.TodoQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Project, Todo, TodoDatasource}
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  def by_project(project, filter \\ %{})

  def by_project(%Project{id: project_id}, filter) do
    archived = Map.get(filter, :archived, false)

    base()
    |> where([t], t.project_id == ^project_id and t.archived == ^archived)
    |> order_by([todo], todo.inserted_at)
    |> Repo.all()
  end

  def by_project(project_id, filter) when is_binary(project_id) do
    by_project(%Project{id: project_id}, filter)
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

  def create!(attrs) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert!()
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

  def archive(%Todo{} = todo) do
    attrs = %{
      archived: true,
      archived_at: NaiveDateTime.utc_now()
    }

    Todo.changeset(todo, attrs)
    |> Repo.update()
  end

  def upsert_datasource!(todo, data) do
    %TodoDatasource{}
    |> TodoDatasource.changeset(Map.merge(%{todo_id: todo.id}, data))
    |> Repo.insert!(on_conflict: :nothing)
  end

  def base do
    # TODO: We need to move these counts into they own columns
    # instead of calculating them on the fly
    from(todo in Todo,
      as: :todo,
      preload: [:project, :datasources],
      select_merge: %{
        open_tasks_count:
          fragment(
            "SELECT count(*) FROM tasks WHERE todo_id = ? AND completed = ?",
            todo.id,
            false
          ),
        completed_tasks_count:
          fragment(
            "SELECT count(*) FROM tasks WHERE todo_id = ? AND completed = ?",
            todo.id,
            true
          )
      }
    )
  end
end
