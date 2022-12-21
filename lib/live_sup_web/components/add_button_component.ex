defmodule LiveSupWeb.Components.AddButtonComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <%= live_patch to: @path, class: "w-10 h-10 block relative ml-2 p-2 transition-colors duration-200 rounded-full text-primary-lighter dark:bg-darker hover:text-primary hover:bg-primary-100 dark:hover:text-light dark:hover:bg-primary-dark dark:bg-dark focus:outline-none focus:bg-primary-100 dark:focus:bg-primary-dark focus:ring-primary-darker" do %>
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
          d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
        />
      </svg>
    <% end %>
    """
  end
end
