defmodule LiveSup.Core.Projects do
  @moduledoc """
  The Projects context.
  """

  alias LiveSup.Schemas.Project
  alias LiveSup.Queries.{ProjectQuery, GroupQuery, ProjectGroupQuery}
  alias LiveSup.Core.{Todos, Dashboards}
  alias Palette.Utils.{ColorHelper, StringHelper}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> all()
      [%Project{}, ...]

  """
  defdelegate all(), to: ProjectQuery
  defdelegate by_user(user), to: ProjectQuery
  defdelegate user_belongs_to?(user_id, resource), to: ProjectQuery

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  defdelegate get!(id), to: ProjectQuery
  defdelegate get(id), to: ProjectQuery
  defdelegate get_with_todos!(id), to: ProjectQuery
  defdelegate get_with_dashboards!(id), to: ProjectQuery

  def get_with_dashboards(id) do
    ProjectQuery.get_with_dashboards(id)
    |> found()
  end

  def get_with_todos(id) do
    ProjectQuery.get_with_todos(id)
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Project{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create(attrs), to: ProjectQuery
  defdelegate create!(attrs), to: ProjectQuery
  defdelegate create_internal_default_project(), to: ProjectQuery

  def create_todo(%Project{} = project, attrs \\ %{}) do
    attrs
    |> StringHelper.keys_to_strings()
    |> Map.merge(%{"project_id" => project.id})
    |> Todos.create()
  end

  def create_public_project(attrs \\ %{}) do
    project =
      attrs
      |> StringHelper.keys_to_strings()
      |> Map.merge(%{"color" => ColorHelper.hex()})
      |> ProjectQuery.create!()

    group = GroupQuery.get_all_users_group()

    ProjectGroupQuery.create!(%{
      project_id: project.id,
      group_id: group.id
    })

    {:ok, project}
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate update(project, attrs), to: ProjectQuery

  @doc """
  Deletes a project.

  ## Examples

      iex> delete(project)
      {:ok, %Project{}}

      iex> delete(project)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete(project), to: ProjectQuery

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  def delete_dashboards(%Project{} = project) do
    project |> Dashboards.delete_all()
  end
end
