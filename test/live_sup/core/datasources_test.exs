defmodule LiveSup.Test.Core.DatasourcesTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  import LiveSup.Test.ProjectsFixtures
  alias LiveSup.Core.Datasources

  describe "datasources" do
    alias LiveSup.Schemas.Datasource

    @valid_attrs %{
      name: "Rollbar",
      slug: "rollbar",
      enabled: true,
      handler: "RollbarDatasource",
      labels: [],
      settings: %{api_key: nil}
    }
    @update_attrs %{name: "New Rollbar", handler: "NewRollbarDatasource"}
    @invalid_attrs %{name: nil, handler: nil}

    def datasource_fixture(attrs \\ %{}) do
      {:ok, datasource} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Datasources.create()

      # We have to reload the datasource
      # otherwise the settings attribute uses atoms
      # instead of strings
      Datasources.get!(datasource.id)
    end

    test "all/0 returns all datasources" do
      datasource = datasource_fixture()
      {:ok, datasources} = Datasources.all()
      assert datasources == [datasource]
    end

    test "get!/1 returns the datasource with given id" do
      datasource = datasource_fixture()
      assert Datasources.get!(datasource.id) == datasource
    end

    test "create/1 with valid data creates a datasource" do
      assert {:ok, %Datasource{} = datasource} = Datasources.create(@valid_attrs)
      assert datasource.labels == []
      assert datasource.name == "Rollbar"
      assert datasource.settings == %{api_key: nil}
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Datasources.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the datasource" do
      datasource = datasource_fixture()
      assert {:ok, %Datasource{} = datasource} = Datasources.update(datasource, @update_attrs)
      assert datasource.labels == []
      assert datasource.name == "New Rollbar"
      assert datasource.settings == %{"api_key" => nil}
    end

    test "update/2 with invalid data returns error changeset" do
      datasource = datasource_fixture()
      assert {:error, %Ecto.Changeset{}} = Datasources.update(datasource, @invalid_attrs)
      assert datasource == Datasources.get!(datasource.id)
    end

    test "delete/1 deletes the datasource" do
      datasource = datasource_fixture()
      assert {:ok, %Datasource{}} = Datasources.delete(datasource)
      assert_raise Ecto.NoResultsError, fn -> Datasources.get!(datasource.id) end
    end

    test "change/1 returns a datasource changeset" do
      datasource = datasource_fixture()
      assert %Ecto.Changeset{} = Datasources.change(datasource)
    end

    test "create_instance/3 create a datasource instance" do
      datasource = datasource_fixture()
      project = project_fixture()

      settings = %{
        api_key: "xxxx"
      }

      {:ok, datasource_instance} =
        datasource
        |> Datasources.create_instance(project, settings)

      assert datasource_instance.name == datasource_instance.name
      assert datasource_instance.settings == settings
      assert datasource_instance.project_id == project.id
    end

    test "create_instance/2 create a pubic datasource instance" do
      datasource = datasource_fixture()

      settings = %{
        api_key: "xxxx"
      }

      {:ok, datasource_instance} =
        datasource
        |> Datasources.create_instance(settings)

      assert datasource_instance.name == datasource_instance.name
      assert datasource_instance.settings == settings
      assert datasource_instance.project_id == nil
    end
  end
end
