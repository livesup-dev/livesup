defmodule LiveSup.Queries.DatasourceQuery do
  import Ecto.Query

  alias LiveSup.Schemas.Datasource
  alias LiveSup.Repo

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_by_slug!(slug) do
    query =
      from(
        ds in Datasource,
        where: ds.slug == ^slug
      )

    query
    |> Repo.one!()
  end

  def get_by_slug(slug) do
    query =
      from(
        ds in Datasource,
        where: ds.slug == ^slug
      )

    query
    |> Repo.one()
  end

  def create(attrs) do
    %Datasource{}
    |> Datasource.changeset(attrs)
    |> Repo.insert()
  end

  def update(project, attrs) do
    project
    |> Datasource.changeset(attrs)
    |> Repo.update()
  end

  def delete(project) do
    project
    |> Repo.delete()
  end

  def base, do: from(Datasource, as: :datasource)
end
