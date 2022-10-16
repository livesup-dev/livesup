defmodule LiveSupWeb.Test.Live.Todo.ManageTaskLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Todo.ManageTaskLive" do
    @describetag :todo_manage_task

    setup [
      :register_and_log_in_user,
      :setup_user_and_default_project,
      :setup_todo,
      :setup_task
    ]

    test "display task", %{conn: conn, task: task} do
      {:ok, _manage_task_live, html} = live(conn, Routes.manage_task_path(conn, :show, task.id))
      assert html =~ "<div class=\"text-3xl text-center mb-3\">#{task.description}</div>"
    end
  end
end
