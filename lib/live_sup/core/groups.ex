defmodule LiveSup.Core.Groups do
  @moduledoc """
  The groups context.
  """

  alias LiveSup.Schemas.{Group, User, UserGroup, Project, ProjectGroup}
  alias LiveSup.Queries.GroupQuery
  alias LiveSup.Repo

  @doc """
  Returns the list of groups.

  ## Examples

      iex> all()
      [%Group{}, ...]

  """
  def all do
    GroupQuery.all()
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: GroupQuery.get!(id)

  @doc """
  Creates a group.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Group{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    attrs
    |> GroupQuery.create()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Group{} = group, attrs) do
    group
    |> GroupQuery.update(attrs)
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete(group)
      {:ok, %Group{}}

      iex> delete(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Group{} = group) do
    group
    |> GroupQuery.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end

  def add_user(%User{} = user, %Group{} = group) do
    UserGroup.changeset(%UserGroup{}, %{
      user_id: user.id,
      group_id: group.id
    })
    |> Repo.insert!()
  end

  def add_user_to_default_group(%User{} = user) do
    group = GroupQuery.get_all_users_group()

    user
    |> add_user(group)
  end

  def add_project(%Project{} = project, %Group{} = group) do
    ProjectGroup.changeset(%ProjectGroup{}, %{
      project_id: project.id,
      group_id: group.id
    })
    |> Repo.insert!()
  end
end
