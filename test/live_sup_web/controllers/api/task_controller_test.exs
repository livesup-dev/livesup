defmodule LiveSupWeb.Api.TaskControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.Setups

  alias LiveSup.Schemas.{Todo, TodoTask}

  @create_attrs %{
    description: "cool desc",
    created_by_id: nil
  }

  @update_attrs %{
    description: "cool desc updated",
    completed: true
  }

  @invalid_attrs %{description: nil}

  setup [:create_user_and_assign_valid_jwt, :setup_project, :setup_task]

  describe "index" do
    @describetag :tasks_request

    test "lists all tasks", %{conn: conn, todo: %{id: todo_id}} do
      conn = get(conn, Routes.api_todo_task_path(conn, :index, todo_id))
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create task" do
    @describetag :tasks_request

    test "renders task when data is valid", %{
      conn: conn,
      todo: %{id: todo_id, created_by_id: created_by_id}
    } do
      conn =
        post(conn, Routes.api_todo_task_path(conn, :create, todo_id),
          task: %{created_by_id: created_by_id, description: @create_attrs.description}
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_task_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "cool desc",
               "todo" => %{
                 "id" => ^todo_id
               },
               "completed" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: %{id: task_id}} do
      conn = post(conn, Routes.api_todo_task_path(conn, :create, task_id), task: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    @describetag :tasks_request

    test "renders todo when data is valid", %{
      conn: conn,
      task: %TodoTask{id: task_id} = task,
      todo: %Todo{id: todo_id}
    } do
      conn = put(conn, Routes.api_task_path(conn, :update, task), task: @update_attrs)

      assert %{"id" => ^task_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_task_path(conn, :show, task_id))

      assert %{
               "id" => ^task_id,
               "description" => "cool desc updated",
               "completed" => true,
               "todo" => %{"id" => ^todo_id}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, Routes.api_task_path(conn, :update, task), task: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    @describetag :tasks_request

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, Routes.api_task_path(conn, :delete, task))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.api_task_path(conn, :show, task))
      end)
    end
  end
end
