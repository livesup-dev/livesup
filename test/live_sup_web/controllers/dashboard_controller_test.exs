defmodule LiveSupWeb.DashboardControllerTest do
  use LiveSupWeb.ConnCase, async: true

  setup [:register_and_log_in_user, :setup_user_and_default_project]

  # TODO: we have to remove this controller
  describe "dashboards" do
    @describetag :dashboards
    @describetag :controllers
    @describetag :skip

    @tag :dashboard_200
    test "get my dashboard", %{conn: conn, dashboard: %{id: dashboard_id}} do
      conn = get(conn, ~p"/dashboards/#{dashboard_id}")
      response = html_response(conn, 200)
      # TODO: We need to find a better way to check if the
      # dashboard has been loaded.
      assert response =~ "href=\"/dashboards/#{dashboard_id}"
    end

    @tag :dashboard_404
    test "handling 404", %{conn: conn} do
      conn = get(conn, ~p"/dashboards/#{"bdb208df-8258-4760-a04a-cdfd71e12fa2"}")
      html_response(conn, 404)
    end

    test "when I dont have access", %{conn: conn} do
      %{dashboard: dashboard} = LiveSup.Test.Setups.setup_dashboard(%{})

      conn = get(conn, ~p"/dashboards/#{dashboard.id}")
      html_response(conn, 404)
    end
  end
end
