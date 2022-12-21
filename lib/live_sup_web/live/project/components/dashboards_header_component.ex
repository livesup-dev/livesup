defmodule LiveSupWeb.Project.Components.DashboardsHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-4/5 flex-wrap">
        <%= link("Home",
          class:
            "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white hidden md:block",
          to: Routes.home_path(LiveSupWeb.Endpoint, :index)
        ) %>
        <%= link("Projects",
          class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white",
          to: Routes.project_path(LiveSupWeb.Endpoint, :index)
        ) %>
        <%= link(@project.name,
          class: "text-blue-500 after:mx-4 after:content-['>'] dark:after:text-white",
          to: Routes.dashboard_path(LiveSupWeb.Endpoint, :index, @project.id)
        ) %>
        <span>Dashboards</span>
      </div>
    </div>
    """
  end
end
