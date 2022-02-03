defmodule LiveSup.Queries.DashboardQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Project, Dashboard}
  alias LiveSup.Repo

  def by_project(%Project{id: project_id}) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> Repo.all()
  end

  def by_project(project_id) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_with_project(id) do
    base()
    |> join(:inner, [d], p in Project, on: d.project_id == p.id)
    |> preload([:project])
    |> Repo.get(id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def create(attrs) do
    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert()
  end

  def update(model, attrs) do
    model
    |> Dashboard.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def default(%Project{} = project) do
    query =
      from(
        d in Dashboard,
        where: d.default == true and d.project_id == ^project.id
      )

    query
    |> Repo.one()
  end

  def base, do: from(Dashboard, as: :dashboard)
end
