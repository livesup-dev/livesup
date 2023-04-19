defmodule LiveSupWeb.Test.Live.Todo.ManageTodoLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Todo.ManageTodoLive" do
    @describetag :todo_manage_todo

    setup [:register_and_log_in_user, :setup_user_and_default_project, :setup_todo]

    test "display todo", %{conn: conn, todo: %{id: todo_id, title: todo_title}} do
      {:ok, _manage_todo_live, html} = live(conn, ~p"/todos/#{todo_id}/manage")

      assert html =~
               "<h2 class=\"text-xl font-medium text-slate-800 dark:text-navy-50 lg:text-2xl\">\n      #{todo_title}\n    </h2>"
    end
  end
end
