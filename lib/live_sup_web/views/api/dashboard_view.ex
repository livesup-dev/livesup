defmodule LiveSupWeb.Api.DashboardView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.{ProjectView, DashboardView}

  def render("index.json", %{dashboards: dashboards}) do
    %{data: render_many(dashboards, DashboardView, "dashboard.json")}
  end

  def render("show.json", %{dashboard: dashboard}) do
    %{data: render_one(dashboard, DashboardView, "dashboard.json")}
  end

  def render("dashboard.json", %{dashboard: %{project: %Ecto.Association.NotLoaded{}} = dashboard}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      labels: dashboard.labels,
      settings: dashboard.settings,
      default: dashboard.default,
      project: %{
        id: dashboard.project_id
      }
    }
  end

  def render("dashboard.json", %{dashboard: dashboard}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      labels: dashboard.labels,
      settings: dashboard.settings,
      default: dashboard.default,
      project: render_one(dashboard.project, ProjectView, "project.json")
    }
  end
end
