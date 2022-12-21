defmodule LiveSupWeb.Components.SidebarComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <%= if assigns[:section] == :dashboard do %>
      <%= LiveSupWeb.Components.DashboardSidebarComponent.render(assigns) %>
    <% end %>

    <%= if assigns[:section] == :project_settings do %>
      <%= LiveSupWeb.Components.ProjectSidebarComponent.render(assigns) %>
    <% end %>

    <%= if assigns[:section] == :dashboard_widgets do %>
      <%= LiveSupWeb.Dashboard.Components.DashboardWidgetSidebarComponent.render(assigns) %>
    <% end %>
    """
  end
end
