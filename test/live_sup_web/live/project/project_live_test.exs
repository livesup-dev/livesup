defmodule LiveSupWeb.Test.Live.ProjectLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "projects" do
    @describetag :project_list

    setup [:register_and_log_in_user, :setup_user_and_default_project]

    test "list projects", %{conn: conn, project: %{name: name}} do
      {:ok, _index_live, html} = live(conn, Routes.project_path(conn, :index))
      assert html =~ "type=\"navigate\">#{name}</a>"
    end
  end
end
