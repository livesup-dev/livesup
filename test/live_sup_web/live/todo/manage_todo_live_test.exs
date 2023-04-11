defmodule LiveSupWeb.Test.Live.Todo.ManageTodoLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Todo.ManageTodoLive" do
    @describetag :todo_manage_todo

    setup [:register_and_log_in_user, :setup_user_and_default_project, :setup_todo]

    test "display todo", %{conn: conn, todo: %{id: todo_id, title: todo_title}} do
      {:ok, _manage_todo_live, html} = live(conn, ~p"/todos/#{todo_id}/manage")

      assert html =~ "<li>#{todo_title}</li>"
    end
  end
end
