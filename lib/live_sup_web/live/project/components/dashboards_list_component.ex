defmodule LiveSupWeb.Project.Components.DashboardsListComponent do
  use LiveSupWeb, :live_component


  def dashboards?(dashboards) do
    Enum.count(dashboards) > 0
  end
end
