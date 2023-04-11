defmodule LiveSupWeb.Api.DashboardController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Dashboards
  alias LiveSup.Schemas.Dashboard

  def index(conn, %{"project_id" => project_id}) do
    dashboards = project_id |> Dashboards.by_project()
    render(conn, "index.json", dashboards: dashboards)
  end

  def create(conn, %{"project_id" => project_id, "dashboard" => dashboard_params}) do
    with {:ok, %Dashboard{} = dashboard} <-
           Dashboards.create(Map.merge(dashboard_params, %{"project_id" => project_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/dashboards/#{dashboard.id}")
      |> render("show.json", dashboard: dashboard)
    end
  end

  def show(conn, %{"id" => id}) do
    dashboard = Dashboards.get!(id)
    render(conn, "show.json", dashboard: dashboard)
  end

  def update(conn, %{"id" => id, "dashboard" => dashboard_params}) do
    dashboard = Dashboards.get!(id)

    with {:ok, %Dashboard{} = dashboard} <-
           Dashboards.update(dashboard, dashboard_params) do
      render(conn, "show.json", dashboard: dashboard)
    end
  end

  def delete(conn, %{"id" => id}) do
    dashboard = Dashboards.get!(id)

    with {:ok, %Dashboard{}} <- Dashboards.delete(dashboard) do
      send_resp(conn, :no_content, "")
    end
  end
end
