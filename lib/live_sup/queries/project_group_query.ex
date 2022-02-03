defmodule LiveSup.Queries.ProjectGroupQuery do
  alias LiveSup.Schemas.ProjectGroup
  alias LiveSup.Repo
  import Ecto.Query

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def create(attrs) do
    attrs
    |> change()
    |> Repo.insert()
  end

  def create!(attrs) do
    attrs
    |> change()
    |> Repo.insert!()
  end

  def change(attrs) do
    %ProjectGroup{}
    |> ProjectGroup.changeset(attrs)
  end

  def update(project, attrs) do
    project
    |> ProjectGroup.changeset(attrs)
    |> Repo.update()
  end

  def delete(resource) do
    resource
    |> Repo.delete()
  end

  def base, do: from(ProjectGroup, as: :project_group)
end
