defmodule LiveSup.Core.Datasources do
  @moduledoc """
  The datasource context.
  """

  alias LiveSup.Schemas.{Datasource, Project, DatasourceInstance}
  alias LiveSup.Queries.{DatasourceQuery, DatasourceInstanceQuery}

  @doc """
  Returns the list of datasource.

  ## Examples

      iex> all()
      [%Datasource{}, ...]

  """
  def all do
    DatasourceQuery.all()
    |> found()
  end

  defp found(nil), do: {:error, :not_found}
  defp found(resource), do: {:ok, resource}

  def global_instances() do
    DatasourceInstanceQuery.global()
  end

  def instances_by_project(%Project{} = project) do
    DatasourceInstanceQuery.all_by_project(project)
  end

  def instances_by_project(project_id) do
    DatasourceInstanceQuery.all_by_project(%Project{id: project_id})
  end

  def search(%Project{} = project, %Datasource{} = datasource) do
    DatasourceInstanceQuery.all_by(project, datasource)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get!(123)
      %Datasource{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: DatasourceQuery.get!(id)
  def get_instance!(instance_id), do: DatasourceInstanceQuery.get!(instance_id)

  def get_by_slug!(slug), do: DatasourceQuery.get_by_slug!(slug)

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Datasource{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    attrs
    |> DatasourceQuery.create()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update(project, %{field: new_value})
      {:ok, %Datasource{}}

      iex> update(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Datasource{} = resource, attrs) do
    resource
    |> DatasourceQuery.update(attrs)
  end

  def update_instance(%DatasourceInstance{} = resource, attrs) do
    resource
    |> DatasourceInstanceQuery.update(attrs)
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete(project)
      {:ok, %Datasource{}}

      iex> delete(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Datasource{} = project) do
    project
    |> DatasourceQuery.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change(datasource)
      %Ecto.Changeset{data: %Datasource{}}

  """
  def change(%Datasource{} = datasource, attrs \\ %{}) do
    Datasource.changeset(datasource, attrs)
  end

  def change_instance(%DatasourceInstance{} = datasource, attrs \\ %{}) do
    DatasourceInstance.changeset(datasource, attrs)
  end

  def create_instance(%Datasource{} = datasource, settings \\ %{}) do
    %{
      name: datasource.name,
      enabled: datasource.enabled,
      settings: settings,
      datasource_id: datasource.id
    }
    |> DatasourceInstanceQuery.create()
  end

  def create_instance(%Datasource{} = datasource, %Project{} = project, settings) do
    %{
      name: datasource.name,
      enabled: datasource.enabled,
      settings: settings,
      datasource_id: datasource.id,
      project_id: project.id
    }
    |> DatasourceInstanceQuery.create()
  end
end
