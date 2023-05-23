defmodule LiveSupWeb.Profile.ShowLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Schemas.User
  alias Palette.Components.Breadcrumb.Step
  alias LiveSup.Core.Links
  import LiveSupWeb.Components.IconsComponent

  @title "Your Profile"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_breadcrumb_steps()
     |> assign_links()
     |> assign(:title, @title)
     |> assign(:page_title, @title)
     |> assign(:section, :profile)}
  end

  defp assign_links(%{assigns: %{current_user: current_user}} = socket) do
    links =
      current_user
      |> Links.get_by_user()

    socket
    |> stream(:links, links)
  end

  defp assign_breadcrumb_steps(%{assigns: %{current_user: current_user}} = socket) do
    steps = [
      %Step{label: "Home", path: "/"},
      %Step{label: User.full_name(current_user)}
    ]

    socket
    |> assign(:steps, steps)
  end
end
