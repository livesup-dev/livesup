defmodule LiveSup.Queries.DashboardQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Project, Dashboard}
  alias LiveSup.Repo

  def by_project(%Project{id: project_id}) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> order_by([dashboard], dashboard.name)
    |> Repo.all()
  end

  def by_project(project_id) do
    base()
    |> where([p], p.project_id == ^project_id)
    |> Repo.all()
  end

  def get!(%Dashboard{id: dashboard_id}) do
    base()
    |> Repo.get!(dashboard_id)
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

  def delete_all() do
    Repo.delete_all(Dashboard)
  end

  def delete_all(%Project{id: project_id}) do
    query =
      from(
        d in Dashboard,
        where: d.project_id == ^project_id
      )

    query
    |> Repo.delete_all()
  end

  def default(%Project{id: project_id}) do
    query =
      from(
        d in Dashboard,
        where: d.default == true and d.project_id == ^project_id
      )

    query
    |> Repo.one()
  end

  def base, do: from(Dashboard, as: :dashboard, preload: [:project])
end
