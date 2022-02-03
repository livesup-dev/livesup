defmodule LiveSupWeb.DashboardController do
  use LiveSupWeb, :controller
  alias LiveSup.Core.{Dashboards, Projects}

  def index(conn, %{"project_id" => project_id}) do
    current_user = conn.assigns.current_user
    dashboards = Dashboards.by_project(project_id)
    project = Projects.get!(project_id)

    render(conn, "index.html",
      current_user: current_user,
      dashboards: dashboards,
      section: :dashboard_selection,
      title: "#{project.name} > Existing dashboards"
    )
  end

  def show(conn, _params) do
    dashboard = conn.assigns.dashboard

    render(
      conn,
      "show.html",
      []
      |> assign_section()
      |> assign_title(dashboard)
      |> assign_project(dashboard)
      |> assign_dashboards(dashboard)
      |> assign_current_dashboard(dashboard)
    )
  end

  defp assign_current_dashboard(list, dashboard) do
    list ++ [current_dashboard: dashboard]
  end

  defp assign_dashboards(list, %{project: %{id: project_id}} = _dashboard) do
    list ++ [dashboards: Dashboards.by_project(project_id)]
  end

  defp assign_title(list, %{project: project} = dashboard) do
    list ++ [title: "#{project.name} > #{dashboard.name}"]
  end

  defp assign_project(list, %{project: project} = _dashboard) do
    list ++ [project: project]
  end

  defp assign_section(list) do
    list ++ [section: :dashboard]
  end
end
