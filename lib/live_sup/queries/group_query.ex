defmodule LiveSup.Queries.GroupQuery do
  import LiveSup.Queries.InternalQueryHelper
  import Ecto.Query

  alias LiveSup.Schemas.Group
  alias LiveSup.Repo

  @administrators_group "administrators"
  @all_users_group "all-users"

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_by_slug(slug) do
    base()
    |> where([g], g.slug == ^slug)
    |> Repo.one()
  end

  def create(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def update(project, attrs) do
    project
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  def delete(group) do
    group
    |> Repo.delete()
  end

  def get_administrator_group do
    base()
    |> with_internal_resource(@administrators_group)
    |> Repo.one()
  end

  def get_all_users_group do
    base()
    |> with_internal_resource(@all_users_group)
    |> Repo.one!()
  end

  def base, do: from(Group, as: :group)
end
