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
      conn = get(conn, "/api/tasks/#{task_id}/comments")
      assert length(json_response(conn, 200)["data"]) == 1
    end
  end

  describe "create comment" do
    @describetag :comments_request

    test "renders comment when data is valid", %{
      conn: conn,
      task: %{id: task_id}
    } do
      conn = post(conn, "/api/tasks/#{task_id}/comments", comment: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, "/api/comments/#{id}")

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
      conn = post(conn, "/api/tasks/#{task_id}/comments", comment: @invalid_attrs)

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
      conn = put(conn, "/api/comments/#{comment.id}", comment: @update_attrs)

      assert %{"id" => ^comment_id} = json_response(conn, 200)["data"]

      conn = get(conn, "/api/comments/#{comment_id}")

      assert %{
               "id" => ^comment_id,
               "body" => "this is a new comment",
               "task" => %{"id" => ^task_id}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment} do
      conn = put(conn, "/api/comments/#{comment.id}", comment: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete comment" do
    @describetag :comments_request

    test "deletes chosen comment", %{conn: conn, comment: comment} do
      conn = delete(conn, "/api/comments/#{comment.id}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, "/api/comments/#{comment.id}")
      end)
    end
  end
end
