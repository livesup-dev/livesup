defmodule LiveSupWeb.Api.ProjectControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.ProjectsFixtures

  alias LiveSup.Schemas.Project

  @create_attrs %{
    avatar_url: "http://hola.com/avatar.jpg",
    internal: true,
    name: "some name"
  }
  @update_attrs %{
    avatar_url: "http://hola.com/avatar2.jpg",
    internal: false,
    name: "some updated name"
  }
  @invalid_attrs %{avatar_url: nil, internal: nil, name: nil}

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, Routes.api_project_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_project_path(conn, :create), project: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_project_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "avatar_url" => "http://hola.com/avatar.jpg",
               "internal" => true,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_project_path(conn, :create), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      conn = put(conn, Routes.api_project_path(conn, :update, project), project: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_project_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "avatar_url" => "http://hola.com/avatar2.jpg",
               "internal" => false,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, Routes.api_project_path(conn, :update, project), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, Routes.api_project_path(conn, :delete, project))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_project_path(conn, :show, project))
      end
    end
  end

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end
end
