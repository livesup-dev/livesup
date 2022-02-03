defmodule LiveSupWeb.Project.Components.DashboardsHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-6/12">
        <%= link "Home", class: "text-blue-500 after:mx-4  after:content-['>'] after:text-white", to: Routes.home_path(LiveSupWeb.Endpoint, :index) %>
        <%= link "Projects", class: "text-blue-500 after:mx-4  after:content-['>'] after:text-white", to: Routes.project_path(LiveSupWeb.Endpoint, :index) %>
        <%= link @project.name, class: "text-blue-500 after:mx-4 after:content-['>'] after:text-white", to: Routes.dashboard_path(LiveSupWeb.Endpoint, :index, @project.id) %>
        <span>Dashboards</span>
      </div>
      <div class="flex justify-end basis-6/12 text-right items-center">
        <%= link to: Routes.datasource_path(LiveSupWeb.Endpoint, :index, @project.id), data: ["tooltip-target": "tooltip-default"], class: "w-10 h-10 block relative ml-2 p-2 transition-colors duration-200 rounded-full text-primary-lighter dark:bg-darker hover:text-primary hover:bg-primary-100 dark:hover:text-light dark:hover:bg-primary-dark dark:bg-dark focus:outline-none focus:bg-primary-100 dark:focus:bg-primary-dark focus:ring-primary-darker" do %>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" />
          </svg>
        <% end %>
        <div id="tooltip-default" role="tooltip" class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip dark:bg-gray-700">
            Tooltip content
            <div class="tooltip-arrow" data-popper-arrow></div>
        </div>
        <%= AddButtonComponent.render(%{path: Routes.dashboard_path(LiveSupWeb.Endpoint, :new, @project.id)}) %>
      </div>
    </div>
    """
  end
end
