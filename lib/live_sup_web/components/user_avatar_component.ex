defmodule LiveSupWeb.Components.UserAvatarComponent do
  use LiveSupWeb, :component
  alias LiveSup.Schemas.User

  def render(assigns) do
    assigns = Map.merge(assigns, %{full_name: User.full_name(assigns[:current_user])})

    ~H"""
    <div class="relative" x-data="{ open: false }">
      <button
        @click="open = !open; $nextTick(() => { if(open){ $refs.userMenu.focus() } })"
        type="button"
        aria-haspopup="true"
        class="transition-opacity duration-200 rounded-full focus:outline-none focus:ring dark:focus:opacity-100"
      >
        <span class="sr-only">User menu</span>
        <img
          class="w-10 h-10 rounded-full"
          src={User.default_avatar_url(@current_user)}
          alt={@full_name}
        />
      </button>
      <!-- User dropdown menu -->
      <div
        x-show="open"
        x-ref="userMenu"
        x-transition:enter="transition-all transform ease-out"
        x-transition:enter-start="translate-y-1/2 opacity-0"
        x-transition:enter-end="translate-y-0 opacity-100"
        x-transition:leave="transition-all transform ease-in"
        x-transition:leave-start="translate-y-0 opacity-100"
        x-transition:leave-end="translate-y-1/2 opacity-0"
        @click.away="open = false"
        @keydown.escape="open = false"
        class="absolute right-0 w-48 py-1 bg-white rounded-md shadow-lg top-12 ring-1 ring-black ring-opacity-5 dark:bg-dark focus:outline-none z-10"
        tabindex="-1"
        role="menu"
        aria-orientation="vertical"
        aria-label="User menu"
      >
        <.link
          href={~p"/users/settings"}
          method={:update}
          class="block px-4 py-2 text-sm text-gray-700 transition-colors hover:bg-gray-100 dark:text-light dark:hover:bg-primary"
        >
          Settings
        </.link>
        <.link
          href={~p"/users/settings"}
          method={:delete}
          class="block px-4 py-2 text-sm text-gray-700 transition-colors hover:bg-gray-100 dark:text-light dark:hover:bg-primary"
        >
          Logout
        </.link>
      </div>
    </div>
    """
  end
end
