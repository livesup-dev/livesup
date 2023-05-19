defmodule LiveSupWeb.Home.IndexLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Favorites
  alias LiveSup.Schemas.User
  alias Palette.Components.Breadcrumb.Step

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_breadcrumb_steps()}
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
end
