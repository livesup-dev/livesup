defmodule LiveSup.Tests.Queries.CommentQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.CommentQuery

  import LiveSup.Test.Setups

  setup [
    :setup_user_and_default_project,
    :setup_task
  ]

  describe "creating a comment" do
    @describetag :comments_query

    @tag :hola
    test "create/1", %{task: %{id: task_id}, user: %{id: user_id}} do
      {:ok, comment} =
        CommentQuery.create(%{
          body: "This is a test",
          created_by_id: user_id,
          task_id: task_id
        })

      assert comment.body == "This is a test"

      assert comment.created_by_id == user_id
      assert comment.task_id == task_id
    end
  end

  describe "managing comments queries" do
    @describetag :comments_query

    setup [:setup_comments]

    test "by_task/1", %{task: task} do
      comments = CommentQuery.by_task(task)

      assert length(comments) == 2

      comments = CommentQuery.by_task(task.id)
      assert length(comments) == 2
    end

    test "return all" do
      comments = CommentQuery.all()

      assert length(comments) == 2
    end
  end

  describe "manage comments" do
    setup [:setup_comment]

    test "get/1", %{comment: comment, user: %{id: user_id}} do
      found_comment = CommentQuery.get(comment.id)
      assert comment.body == found_comment.body

      found_comment = CommentQuery.get(comment)
      assert comment.body == found_comment.body
      assert comment.created_by_id == user_id
    end

    test "get!/1", %{comment: comment} do
      found_comment = CommentQuery.get!(comment.id)
      assert found_comment.body == found_comment.body
    end

    test "update/2", %{comment: comment} do
      comment = CommentQuery.get!(comment.id)

      {:ok, _saved_comment} = CommentQuery.update(comment, %{body: "new comment"})

      found_comment = CommentQuery.get!(comment.id)
      assert found_comment.body == "new comment"
    end
  end
end
