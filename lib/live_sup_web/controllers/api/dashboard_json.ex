defmodule LiveSupWeb.Api.DashboardJSON do
  alias LiveSupWeb.Api.{ProjectJSON, DashboardJSON}
  alias LiveSup.Schemas.Dashboard

  def index(%{dashboards: dashboards}) do
    %{data: for(dashboard <- dashboards, do: data(dashboard))}
  end

  def show(%{dashboard: dashboard}) do
    %{data: data(dashboard)}
  end

  def data(%Dashboard{project: %Ecto.Association.NotLoaded{}} = dashboard) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      labels: dashboard.labels,
      settings: dashboard.settings,
      default: dashboard.default,
      project: %{
        id: dashboard.project_id
      },
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at
    }
  end

  def data(%Dashboard{} = dashboard) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      labels: dashboard.labels,
      settings: dashboard.settings,
      default: dashboard.default,
      project: ProjectJSON.show(project: dashboard.project),
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at
    }
  end
end
