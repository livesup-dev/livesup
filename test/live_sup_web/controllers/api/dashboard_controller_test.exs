defmodule LiveSupWeb.Api.DashboardControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.DashboardsFixtures
  import LiveSup.Test.Setups

  alias LiveSup.Schemas.Dashboard

  @create_attrs %{
    name: "some name",
    settings: %{},
    default: true
  }

  @update_attrs %{
    name: "some updated name",
    settings: %{hola: :chau},
    default: false
  }

  @invalid_attrs %{name: nil, settings: nil, default: nil}

  setup [:create_user_and_assign_valid_jwt, :setup_project]

  describe "index" do
    @describetag :dashboards_request

    test "lists all dashboards", %{conn: conn, project: %{id: project_id}} do
      conn = get(conn, "/api/projects/#{project_id}/dashboards")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create dashboard" do
    @describetag :dashboards_request

    test "renders dashboard when data is valid", %{conn: conn, project: %{id: project_id}} do
      conn = post(conn, "/api/projects/#{project_id}/dashboards", dashboard: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, "/api/dashboards/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "settings" => %{},
               "default" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: %{id: project_id}} do
      conn = post(conn, "/api/projects/#{project_id}/dashboards", dashboard: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update dashboard" do
    @describetag :dashboards_request

    setup [:create_dashboard]

    test "renders dashboard when data is valid", %{
      conn: conn,
      dashboard: %Dashboard{id: id} = dashboard
    } do
      conn = put(conn, "/api/dashboards/#{dashboard.id}", dashboard: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, "/api/dashboards/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "settings" => %{},
               "default" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, dashboard: dashboard} do
      conn = put(conn, "/api/dashboards/#{dashboard.id}", dashboard: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete dashboard" do
    @describetag :dashboards_request

    setup [:create_dashboard]

    test "deletes chosen dashboard", %{conn: conn, dashboard: dashboard} do
      conn = delete(conn, "/api/dashboards/#{dashboard.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, "/api/dashboards/#{dashboard.id}")
      end
    end
  end

  defp create_dashboard(%{project: project}) do
    dashboard = dashboard_fixture(project)
    %{dashboard: dashboard}
  end
end
