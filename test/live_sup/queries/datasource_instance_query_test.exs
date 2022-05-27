defmodule LiveSup.Tests.Queries.DatasourceInstanceQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.DatasourceInstanceQuery
  alias LiveSup.Core.Datasources
  alias LiveSup.Test.{DatasourcesFixtures, ProjectsFixtures}

  describe "managing datasource instances queries" do
    @describetag :datasource_instance_query

    setup [:setup_global_datasources, :setup_project_datasources]

    test "return global datasources" do
      datasource_instances = DatasourceInstanceQuery.global()
      assert length(datasource_instances) == 2
    end

    @tag :count_datsource_instance
    test "count datasource instances" do
      assert DatasourceInstanceQuery.count() == 3
    end

    @tag :instance_by_datasource
    test "get instance by datasource id", %{datasource: datasource} do
      datasource_instance = datasource |> DatasourceInstanceQuery.by_datasource()
      assert datasource_instance != nil
    end

    @tag :instance_by_datasource
    test "get instance by datasource slug", %{datasource: datasource} do
      datasource_instance = datasource.slug |> DatasourceInstanceQuery.by_datasource()
      assert datasource_instance != nil
    end

    test "return all available datasources for a project", %{project: project} do
      datasource_instances = DatasourceInstanceQuery.all_by_project(project)
      assert length(datasource_instances) == 3
    end
  end

  def setup_global_datasources(context) do
    datasource = DatasourcesFixtures.datasource_fixture()
    Datasources.create_instance(datasource)
    Datasources.create_instance(datasource)

    context
    |> Map.put(:datasource, datasource)
  end

  def setup_project_datasources(context) do
    project = ProjectsFixtures.project_fixture()
    datasource = DatasourcesFixtures.datasource_fixture()
    Datasources.create_instance(datasource, project, %{my_key: "xxxx"})

    %{project: project}
    |> Enum.into(context)
  end
end
