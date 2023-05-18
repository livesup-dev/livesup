defmodule LiveSup.Queries.GroupQuery do
  import LiveSup.Queries.InternalQueryHelper
  import Ecto.Query

  alias LiveSup.Schemas.{Group, UserGroup}
  alias LiveSup.Repo

  @administrators_group "administrators"
  @all_users_group "all-users"

  def count do
    base()
    |> Repo.aggregate(:count)
  end

  def all do
    base()
    |> Repo.all()
  end

  def internal_groups() do
    base()
    |> where([g], g.internal == true)
    |> Repo.all()
  end

  def non_internal_groups() do
    base()
    |> where([g], g.internal == false)
    |> Repo.all()
  end

  def get(id) do
    base()
    |> Repo.get(id)
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

  def delete_all do
    base()
    |> Repo.delete_all()
  end

  def member?(group, user) do
    from(UserGroup, as: :user_group)
    |> where([user_group: ug], ug.user_id == ^user.id and ug.group_id == ^group.id)
    |> Repo.exists?()
  end

  def base, do: from(Group, as: :group)
end
