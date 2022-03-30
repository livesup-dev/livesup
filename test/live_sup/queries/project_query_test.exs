defmodule LiveSup.Tests.Queries.ProjectQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.ProjectQuery
  alias LiveSup.Test.ProjectsFixtures
  alias LiveSup.Core.Projects

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project
  ]

  describe "managing project queries" do
    @describetag :project_query

    test "return default internal project", %{project: %{id: id}} do
      default_project = ProjectQuery.get_internal_default_project()
      assert default_project.id == id
    end

    test "return projects by users", %{user: user} do
      projects =
        user
        |> ProjectQuery.by_user()

      assert [%{name: "My Stuff"}] = projects
    end
  end

  describe "deleting projects" do
    @describetag :project_query
    setup do
      project = ProjectsFixtures.project_fixture()
      {:ok, project: project}
    end

    test "delete the project", %{project: project} do
      {:ok, deleted_project} =
        project
        |> ProjectQuery.delete()

      assert Projects.get(deleted_project.id) == nil
    end
  end
end
