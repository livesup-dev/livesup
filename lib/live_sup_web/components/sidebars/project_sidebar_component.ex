defmodule LiveSupWeb.Components.ProjectSidebarComponent do
  use LiveSupWeb, :component
  alias LiveSupWeb.Live.Components.SidebarHelper

  def render(assigns) do
    ~H"""
    <!-- Sidebar -->
    <SidebarHelper.sidebar>
      <SidebarHelper.menu>
        <SidebarHelper.parent name="Settings" active="true" icon="ri-database-2-line">
          <SidebarHelper.item
            active="false"
            label="Datasources"
            path={Routes.datasource_path(LiveSupWeb.Endpoint, :index, @project.id)}
          />
        </SidebarHelper.parent>
      </SidebarHelper.menu>
      <SidebarHelper.footer />
    </SidebarHelper.sidebar>
    <!-- /Sidebar -->
    """
  end
end
