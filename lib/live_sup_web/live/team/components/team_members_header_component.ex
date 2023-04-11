defmodule LiveSupWeb.Teams.Components.TeamMembersHeaderComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <div class="justify-between flex flex-row space-x-4 border-b dark:border-primary-darker px-4 py-2">
      <div class="flex items-center basis-4/5 flex-wrap">
        <%= link("Home",
          class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white",
          to: ~p"/"
        ) %>
        <%= link("Teams",
          class: "text-blue-500 after:mx-4  after:content-['>'] dark:after:text-white",
          to: ~p"/teams"
        ) %>
        <span><%= @team.name %></span>
      </div>
      <div class="flex justify-end basis-1/5 text-right items-center">
        <%= link to: ~p"/teams/#{@team.id}/edit", class: "w-10 h-10 block relative ml-2 p-2 transition-colors duration-200 rounded-full text-primary-lighter dark:bg-darker hover:text-primary hover:bg-primary-100 dark:hover:text-light dark:hover:bg-primary-dark dark:bg-dark focus:outline-none focus:bg-primary-100 dark:focus:bg-primary-dark focus:ring-primary-darker" do %>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
            />
          </svg>
        <% end %>
        <%= AddButtonComponent.render(%{
          path: ~p"/teams/#{@team.id}/members/add"
        }) %>
      </div>
    </div>
    """
  end
end
