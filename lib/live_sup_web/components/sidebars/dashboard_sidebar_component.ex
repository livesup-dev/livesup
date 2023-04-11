defmodule LiveSupWeb.Components.DashboardSidebarComponent do
  use LiveSupWeb, :component
  alias LiveSupWeb.Live.Components.SidebarHelper

  def render(assigns) do
    ~H"""
    <!-- Sidebar -->
    <SidebarHelper.sidebar>
      <SidebarHelper.menu>
        <SidebarHelper.parent name={@project.name} active="true" icon="dashboard-2-line">
          <%= for dashboard <- @dashboards do %>
            <SidebarHelper.item
              active={@current_dashboard.id == dashboard.id}
              label={dashboard.name}
              path={~p"/dashboards/#{dashboard.id}"}
            />
          <% end %>
        </SidebarHelper.parent>
      </SidebarHelper.menu>
      <SidebarHelper.footer />
    </SidebarHelper.sidebar>
    <!-- /Sidebar -->
    """
  end
end
