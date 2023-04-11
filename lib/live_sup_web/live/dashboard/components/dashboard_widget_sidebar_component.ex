defmodule LiveSupWeb.Dashboard.Components.DashboardWidgetSidebarComponent do
  use LiveSupWeb, :component
  alias LiveSupWeb.Live.Components.SidebarHelper
  alias LiveSup.Core.Datasources

  def render(assigns) do
    assigns =
      assigns
      |> assign_datasources()

    ~H"""
    <!-- Sidebar -->
    <SidebarHelper.sidebar>
      <SidebarHelper.menu>
        <SidebarHelper.parent name="Datasources" active="true" icon="ri-database-2-line">
          <SidebarHelper.item label="All" path={~p"/dashboards/#{@dashboard.id}/widgets"} />
          <%= for datasource_instance <- @datasource_instances do %>
            <SidebarHelper.item
              active="false"
              label={datasource_instance.name}
              path={
                Routes.widget_path(LiveSupWeb.Endpoint, :show, @dashboard.id, %{
                  datasource_id: datasource_instance.datasource_id
                })
              }
            />
          <% end %>
        </SidebarHelper.parent>
      </SidebarHelper.menu>
      <SidebarHelper.footer />
    </SidebarHelper.sidebar>
    <!-- /Sidebar -->
    """
  end

  defp assign_datasources(%{dashboard: %{project: project}} = assigns) do
    assigns
    |> Map.put(:datasource_instances, Datasources.instances_by_project(project))
  end
end
