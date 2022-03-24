defmodule LiveSupWeb.Teams.Components.TeamsHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-4/5 flex-wrap">
        <%= link "Home", class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.home_path(LiveSupWeb.Endpoint, :index) %>
        <span>Teams</span>
      </div>
      <div class="flex justify-end basis-1/5 text-right items-center">
        <%= AddButtonComponent.render(%{path: Routes.team_list_path(LiveSupWeb.Endpoint, :new)}) %>
      </div>
    </div>
    """
  end
end
