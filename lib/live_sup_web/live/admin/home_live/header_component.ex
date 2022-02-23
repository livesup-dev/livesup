defmodule LiveSupWeb.Admin.HomeLive.HeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-6/12">
        <%= link "Home", class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white", to: Routes.home_path(LiveSupWeb.Endpoint, :index) %>
        <span>Admin</span>
      </div>
    </div>
    """
  end
end
