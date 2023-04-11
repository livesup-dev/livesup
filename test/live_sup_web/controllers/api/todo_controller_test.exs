defmodule LiveSupWeb.Api.TodoControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.TodosFixtures
  import LiveSup.Test.Setups

  alias LiveSup.Schemas.{Todo, Project}

  @create_attrs %{
    title: "some name",
    description: "cool desc"
  }

  @update_attrs %{
    title: "updated title",
    description: "cool desc updated"
  }

  @invalid_attrs %{title: nil}

  setup [:create_user_and_assign_valid_jwt, :setup_project, :setup_todos]

  describe "index" do
    @describetag :todos_request

    test "lists all todos", %{conn: conn, project: %{id: project_id}} do
      conn = get(conn, ~p"/api/projects/#{project_id}/todos")
      assert length(json_response(conn, 200)["data"]) == 2
    end
  end

  describe "create todo" do
    @describetag :todos_request

    test "renders todo when data is valid", %{
      conn: conn,
      project: %{id: project_id, name: project_name}
    } do
      conn = post(conn, ~p"/api/projects/#{project_id}/todos", todo: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/todos/#{id}")

      assert %{
               "id" => ^id,
               "color_code" => nil,
               "description" => "cool desc",
               "project" => %{
                 "avatar_url" => nil,
                 "id" => ^project_id,
                 "internal" => false,
                 "name" => ^project_name
               },
               "title" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: %{id: project_id}} do
      conn = post(conn, ~p"/api/projects/#{project_id}/todos", todo: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update todo" do
    @describetag :todos_request

    setup [:create_todo]

    test "renders todo when data is valid", %{
      conn: conn,
      project: %Project{id: project_id},
      todos: [%Todo{id: id} = todo, _second_todo]
    } do
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/todos/#{id}")

      assert %{
               "id" => ^id,
               "title" => "updated title",
               "color_code" => "#fff",
               "project" => %{"id" => ^project_id}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    @describetag :todos_request

    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, ~p"/api/todos/#{todo}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/todos/#{todo}")
      end)
    end
  end

  defp create_todo(%{project: project}) do
    todo = todo_fixture(project)
    %{todo: todo}
  end
end
