defmodule LiveSupWeb.Test.Live.Project.BoardLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "project.board" do
    @describetag :project_board

    setup [:register_and_log_in_user, :setup_user_and_default_project, :setup_todos]

    test "show board", %{conn: conn, project: %{id: project_id, name: name}} do
      {:ok, _index_live, html} = live(conn, "/projects")

      assert html =~ "\n#{name}\n"
    end
  end
end
