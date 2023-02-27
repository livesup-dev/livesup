defmodule LiveSupWeb.Api.CommentControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.Setups

  alias LiveSup.Schemas.Comment

  @create_attrs %{
    body: "cool desc"
  }

  @update_attrs %{
    body: "this is a new comment"
  }

  @invalid_attrs %{body: nil}

  setup [:create_user_and_assign_valid_jwt, :setup_project, :setup_task, :setup_comment]

  describe "index" do
    @describetag :comments_request

    test "lists all comments", %{conn: conn, task: %{id: task_id}} do
      conn = get(conn, Routes.api_task_comment_path(conn, :index, task_id))
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create comment" do
    @describetag :comments_request

    test "renders comment when data is valid", %{
      conn: conn,
      task: %{id: task_id}
    } do
      conn =
        post(conn, Routes.api_task_comment_path(conn, :create, task_id), comment: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_comment_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "body" => "cool desc",
               "task" => %{
                 "id" => ^task_id
               }
             } = json_response(conn, 200)["data"]
    end

    @tag :emi2
    test "renders errors when data is invalid", %{conn: conn, task: %{id: task_id}} do
      conn =
        post(conn, Routes.api_task_comment_path(conn, :create, task_id), comment: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update comment" do
    @describetag :comments_request

    test "renders comment when data is valid", %{
      conn: conn,
      task: %{id: task_id},
      comment: %Comment{id: comment_id} = comment
    } do
      conn = put(conn, Routes.api_comment_path(conn, :update, comment), comment: @update_attrs)

      assert %{"id" => ^comment_id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_comment_path(conn, :show, comment_id))

      assert %{
               "id" => ^comment_id,
               "body" => "this is a new comment",
               "task" => %{"id" => ^task_id}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn = put(conn, Routes.api_comment_path(conn, :update, comment), comment: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    @describetag :comments_request

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, Routes.api_comment_path(conn, :delete, comment))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.api_comment_path(conn, :show, comment))
      end)
    end
  end
end
