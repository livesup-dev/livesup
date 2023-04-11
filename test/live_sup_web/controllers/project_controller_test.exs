defmodule LiveSupWeb.ProjectControllerTest do
  use LiveSupWeb.ConnCase, async: true

  alias LiveSup.Test.ProjectsFixtures

  setup [:register_and_log_in_user, :setup_user_and_default_project]

  describe "projects" do
    @describetag :skip
    @describetag :projects
    @describetag :controllers

    test "get a list of all my projects", %{conn: conn, project: %{id: id, name: name}} do
      conn = get(conn, ~p"/projects")
      response = html_response(conn, 200)
      assert response =~ "Select a project"
      assert response =~ "<a href=\"/projects/#{id}/dashboards\"> #{name} </a>"
    end

    test "show project", %{conn: conn, project: %{id: id, name: name}} do
      conn = get(conn, Routes.project_path(conn, :show, id))
      response = html_response(conn, 200)
      assert response =~ "Your project: #{name}"
    end

    test "when I dont have access", %{conn: conn} do
      another_project = ProjectsFixtures.project_fixture()

      conn = get(conn, Routes.project_path(conn, :show, another_project.id))
      assert html_response(conn, 404)
    end

    test "when the project doesn't exists", %{conn: conn} do
      conn = get(conn, Routes.project_path(conn, :show, "e8fe7070-6452-43d6-947c-9e36e486e11c"))
      assert html_response(conn, 404)
    end
  end
end
