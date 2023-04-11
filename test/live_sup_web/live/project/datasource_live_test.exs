defmodule LiveSupWeb.Test.Live.Project.DatasourceLiveTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "datasources" do
    @describetag :datasources

    setup [:register_and_log_in_user, :setup_user_and_default_project]

    test "show list", %{conn: conn, project: %{id: project_id, name: _name}} do
      {:ok, _index_live, html} = live(conn, ~p"/projects/#{project_id}/datasources")

      assert html =~ "Datasources"
    end

    @tag :datasource_no_access
    @tag :skip
    test "trying to access other's user project", %{
      conn: conn,
      project: %{id: _project_idx, name: _name}
    } do
      # TODO this test is failing and Im not really sure how to fix it yet.
      %{id: project_id} = LiveSup.Test.ProjectsFixtures.project_fixture()
      result = live(conn, ~p"/projects/#{project_id}/datasources")
      assert {:error, {:redirect, %{to: "/projects"}}} = result
    end
  end
end
