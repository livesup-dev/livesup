defmodule LiveSupWeb.Home.IndexLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Favorites
  alias LiveSup.Schemas.User
  alias Palette.Components.Breadcrumb.Step
  alias LiveSupWeb.Home.Components.FavoriteRowComponent

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_breadcrumb_steps()
     |> assign_favorites()}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Home"}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "Home")
    |> assign_page_title("Home")
    |> assign(section: :home)
  end

  defp assign_page_title(socket, title) do
    socket
    |> assign(:page_title, title)
  end

  defp assign_favorites(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> stream(:favorites, Favorites.all(current_user))
  end
end
