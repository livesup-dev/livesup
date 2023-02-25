defmodule LiveSupWeb.Teams.MembersLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.User

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(%{"id" => team_id}, _session, socket) do
    {:ok,
     socket
     |> assign_title()
     |> assign_team(team_id)
     |> assign_page_title("Teams")}
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

  defp assign_title(socket) do
    socket
    |> assign(title: "Teams")
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
