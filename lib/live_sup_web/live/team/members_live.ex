defmodule LiveSupWeb.Teams.MembersLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.User

  on_mount(LiveSupWeb.UserLiveAuth)

  alias Palette.Components.Breadcrumb.Step

  @impl true
  def mount(%{"id" => team_id}, _session, socket) do
    {:ok,
     socket
     |> assign_team(team_id)
     |> assign_defaults()
     |> assign_breadcrumb_steps()}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Home", path: "/"},
      %Step{label: "Teams", path: "/teams"},
      %Step{label: "Members"}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_defaults(socket) do
    socket
    |> assign(section: :teams)
    |> assign_title()
    |> assign_page_title("Teams")
  end

  defp assign_page_title(socket, page_title) do
    socket
    |> assign(page_title: page_title)
  end

  defp assign_team(socket, team_id) do
    team = Teams.get!(team_id)

    socket
    |> assign(team: team)
  end

  defp assign_title(%{assigns: %{team: %{name: name}}} = socket) do
    socket
    |> assign(title: name)
  end

  @impl true
  def handle_params(%{"id" => team_id}, _url, socket) do
    {:noreply, socket |> assign_team(team_id)}
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign_page_title("New team")
  #   |> assign(:team, %Team{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign_page_title("Teams")
  #   |> assign(:team, nil)
  # end
end
