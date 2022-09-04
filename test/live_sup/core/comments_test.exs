defmodule LiveSup.Test.Core.CommentsTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Core.Comments
  import LiveSup.Test.Setups

  describe "comments" do
    @describetag :comments

    setup [:setup_user, :setup_project, :setup_task, :setup_comment]

    test "by_task/0 returns all comments by task", %{task: task, comment: comment} do
      assert Comments.by_task(task) == [comment]
    end

    test "get!/1 returns the comment with given id", %{comment: comment} do
      assert Comments.get!(comment.id) == comment
    end

    test "get/1 returns the comment with given id", %{comment: comment} do
      assert Comments.get(comment.id) == {:ok, comment}
    end
  end
end
