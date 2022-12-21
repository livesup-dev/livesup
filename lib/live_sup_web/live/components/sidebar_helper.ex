defmodule LiveSupWeb.Live.Components.SidebarHelper do
  use Phoenix.Component

  import LiveSupWeb.Helpers

  @doc """
  Renders sidebar container.
  Other functions in this module render sidebar
  items of various type.
  """
  def sidebar(assigns) do
    # TODO: For some reason the <hidden> class is not being removed
    # when the app is ready, so I had to remove it, but if I try the mobile view
    # the sidebar doesn't go away
    # This is the original html:
    # <aside class="flex-shrink-0 hidden w-64 bg-white border-r dark:border-primary-darker dark:bg-darker md:block">
    ~H"""
    <aside class="flex-shrink-0 w-64 hidden  bg-white border-r dark:border-primary-darker dark:bg-darker md:block">
      <div class="flex flex-col h-full">
        <%= render_block(@inner_block) %>
      </div>
    </aside>
    """
  end

  def menu(assigns) do
    ~H"""
    <nav aria-label="Main" class="flex-1 px-2 py-4 space-y-2 overflow-y-hidden hover:overflow-y-auto">
      <%= render_block(@inner_block) %>
    </nav>
    """
  end

  def footer(assigns) do
    ~H"""
    <div class="flex-shrink-0 px-2 py-4 space-y-2">
      <button
        @click="openSettingsPanel"
        type="button"
        class="flex items-center justify-center w-full px-4 py-2 text-sm text-white rounded-md bg-primary hover:bg-primary-dark focus:outline-none focus:ring focus:ring-primary-dark focus:ring-offset-1 focus:ring-offset-white dark:focus:ring-offset-dark"
      >
        <span aria-hidden="true">
          <svg
            class="w-4 h-4 mr-2"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
            />
          </svg>
        </span>
        <span>Customize</span>
      </button>
    </div>
    """
  end

  def item(assigns) do
    class =
      if assigns[:active] do
        "block p-2 text-sm text-gray-700 transition-colors duration-200 rounded-md dark:text-light dark:hover:text-light hover:text-gray-700"
      else
        "block p-2 text-sm text-gray-400 transition-colors duration-200 rounded-md dark:hover:text-light hover:text-gray-700"
      end

    assigns =
      assigns
      |> assign(:class, class)

    ~H"""
    <%= live_patch(@label,
      to: @path,
      class: @class
    ) %>
    """
  end

  def parent(assigns) do
    assigns =
      assigns
      |> assign_new(:menu_state, fn ->
        "{ isActive: #{assigns[:active]}, open: #{assigns[:active]}}"
      end)

    ~H"""
    <div x-data={@menu_state}>
      <a
        href="#"
        @click="$event.preventDefault(); open = !open"
        class="flex items-center p-2 text-gray-500 transition-colors rounded-md dark:text-light hover:bg-primary-100 dark:hover:bg-primary"
        role="button"
        aria-haspopup="true"
      >
        <span aria-hidden="true">
          <.remix_icon icon={@icon} />
        </span>
        <span class="ml-2 text-sm"><%= @name %></span>
        <span class="ml-auto" aria-hidden="true">
          <svg
            class="w-4 h-4 transition-transform transform"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
          </svg>
        </span>
      </a>
      <div role="menu" x-show="open" class="mt-2 space-y-2 px-7" aria-label="Dashboards">
        <!-- active & hover classes 'text-gray-700 dark:text-light' -->
        <!-- inActive classes 'text-gray-400 dark:text-gray-400' -->
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end
end
