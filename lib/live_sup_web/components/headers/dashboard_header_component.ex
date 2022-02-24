defmodule LiveSupWeb.Components.DashboardHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-6/12">
        <%= link "Home", class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.home_path(LiveSupWeb.Endpoint, :index) %>
        <%= link "Projects", class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.project_path(LiveSupWeb.Endpoint, :index) %>
        <%= link @project.name, class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.dashboard_path(LiveSupWeb.Endpoint, :index, @project.id) %>
        <%= link "Dashboards", class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.dashboard_path(LiveSupWeb.Endpoint, :index, @project.id) %>
        <span><%= @dashboard.name %></span>
      </div>
      <div class="flex justify-end basis-6/12 text-right items-center">
        <%= link to: Routes.widget_path(LiveSupWeb.Endpoint, :show, @dashboard.id), class: "w-10 h-10 block relative ml-2 p-2 transition-colors duration-200 rounded-full text-primary-lighter dark:bg-darker hover:text-primary hover:bg-primary-100 dark:hover:text-light dark:hover:bg-primary-dark dark:bg-dark focus:outline-none focus:bg-primary-100 dark:focus:bg-primary-dark focus:ring-primary-darker" do %>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
          </svg>
        <% end %>
    	</div>
    </div>
    """
  end
end
