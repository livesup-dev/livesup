defmodule LiveSup.Queries.DatasourceInstanceQuery do
  import Ecto.Query
  alias LiveSup.Schemas.{DatasourceInstance, Project, Datasource}
  alias LiveSup.Repo

  def count do
    base()
    |> Repo.aggregate(:count)
  end

  def all do
    base()
    |> Repo.all()
  end

  def global() do
    global_instances_query()
    |> Repo.all()
  end

  def by_project(%Project{id: project_id}) do
    by_project_query(project_id)
    |> join_datasource()
    |> order_by([di], asc: di.name)
    |> Repo.all()
  end

  def by_datasource(%Datasource{id: datasource_id}) do
    # TODO: We should also fitler by settings
    base()
    |> join_datasource()
    |> where([di], di.datasource_id == ^datasource_id)
    |> Repo.all()
  end

  def by_datasource(slug) when is_binary(slug) do
    # TODO: We should also fitler by settings
    base()
    |> join_datasource()
    |> where([datasource: datasource], datasource.slug == ^slug)
    |> Repo.all()
  end

  def all_by(%Project{id: project_id}, %Datasource{id: datasource_id} = datasource) do
    query =
      project_id
      |> by_project_query()
      |> by_datasource_query(datasource_id)
      |> where([di], di.enabled == true)

    union_all(query, ^global_instances_query(datasource))
    |> Repo.all()
  end

  def all_by_project(%Project{id: project_id}) do
    by_project_query =
      from(DatasourceInstance, as: :datasource_instance)
      |> where([di], di.project_id == ^project_id)
      |> where([di], di.enabled == true)

    global_instances_query =
      from(DatasourceInstance, as: :datasource_instance)
      |> where([di], is_nil(di.project_id))

    union_query = union_all(by_project_query, ^global_instances_query)

    from(u in subquery(union_query), order_by: u.name)
    |> preload([:datasource])
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def create(attrs) do
    %DatasourceInstance{}
    |> DatasourceInstance.changeset(attrs)
    |> Repo.insert()
  end

  def update(project, attrs) do
    project
    |> DatasourceInstance.changeset(attrs)
    |> Repo.update()
  end

  def delete(project) do
    project
    |> Repo.delete()
  end

  defp global_instances_query() do
    base()
    |> where([di], is_nil(di.project_id))
  end

  # TODO: Change this to an OR condition
  defp global_instances_query(%Datasource{id: datasource_id}) do
    base_without_preload()
    |> where([di], is_nil(di.project_id) and di.datasource_id == ^datasource_id)
  end

  defp by_project_query(project_id) do
    base()
    |> where([di], di.project_id == ^project_id)
  end

  defp by_datasource_query(query, datasource_id) do
    query
    |> where([di], di.datasource_id == ^datasource_id)
  end

  defp join_datasource(query) do
    query
    |> join(:inner, [di], d in assoc(di, :datasource), as: :datasource)
  end

  def base, do: from(DatasourceInstance, as: :datasource_instance, preload: [:datasource])
  def base_without_preload, do: from(DatasourceInstance, as: :datasource_instance)
end
