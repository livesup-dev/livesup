defmodule LiveSup.Test.Core.ProjectsTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Core.Projects
  import LiveSup.Test.Setups

  describe "projects" do
    @describetag :projects

    alias LiveSup.Schemas.Project

    @valid_attrs %{internal: true, labels: [], name: "some name", settings: %{}}
    @valid_public_attrs %{internal: false, labels: [], name: "public project", settings: %{}}
    @update_attrs %{internal: false, labels: [], name: "some updated name", settings: %{}}
    @invalid_attrs %{internal: nil, labels: nil, name: nil, settings: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.all() == [project]
    end

    test "get!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get!(project.id) == project
    end

    test "get!/1 returns the project with given id and the associated dashboards" do
      project = project_fixture()

      # Creates a dashboard for the project
      %{project: project}
      |> setup_dashboard()

      found_project = Projects.get_with_dashboards!(project.id)

      assert %{
               name: "some name",
               dashboards: [%{name: "Cool Dashboard"}]
             } = found_project
    end

    test "create/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Projects.create(@valid_attrs)
      assert project.internal == true
      assert project.labels == []
      assert project.name == "some name"
      assert project.settings == %{}
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Projects.update(project, @update_attrs)
      assert project.internal == false
      assert project.labels == []
      assert project.name == "some updated name"
      assert project.settings == %{}
    end

    test "update/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update(project, @invalid_attrs)
      assert project == Projects.get!(project.id)
    end

    test "delete/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get!(project.id) end
    end

    test "change/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change(project)
    end

    @tag :create_public_project
    test "create_public_project/1 create public project" do
      user =
        %{}
        |> setup_groups()
        |> setup_user_with_groups()
        |> Map.get(:user)

      {:ok, project} =
        @valid_public_attrs
        |> Projects.create_public_project()

      assert @valid_public_attrs = project

      assert [%{name: "public project"}] = user |> Projects.by_user()
    end
  end
end
