defmodule LiveSupWeb.Live.Teams.Index do
  use LiveSupWeb, :live_view

  alias Exmoji.EmojiChar
  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.{Team, User}
  alias Palette.Components.Breadcrumb.Step

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_breadcrumb_steps()
     |> assign_teams()}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Home", path: "/"},
      %Step{label: "Teams"}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_page_title(socket, page_title) do
    socket
    |> assign(page_title: page_title)
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "Teams")
    |> assign(:team, %Team{})
    |> assign_page_title("Teams")
    |> assign(section: :teams)
  end

  defp assign_teams(socket) do
    socket
    |> stream(:teams, Teams.all())
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign_page_title("New team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :edit, %{"id" => team_id}) do
    socket
    |> assign_page_title("Edit team")
    |> assign(:team, Teams.get!(team_id))
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp team_avatar(%Team{avatar: nil}) do
    Exmoji.from_short_name("alien") |> EmojiChar.render()
  end

  defp team_avatar(%Team{avatar: avatar}) do
    Exmoji.from_short_name(avatar) |> EmojiChar.render()
  end
end
