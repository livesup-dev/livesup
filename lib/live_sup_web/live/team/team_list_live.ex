defmodule LiveSupWeb.Teams.TeamListLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.Team

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     socket
     |> assign_title()
     |> assign_current_user(current_user)
     |> assign_page_title("Teams")
     |> assign(:team, nil)
     |> assign_teams()}
  end

  defp assign_page_title(socket, page_title) do
    socket
    |> assign(page_title: page_title)
  end

  defp assign_current_user(socket, current_user) do
    socket
    |> assign(current_user: current_user)
  end

  defp assign_title(socket) do
    socket
    |> assign(title: "Teams")
  end

  defp assign_teams(socket) do
    socket
    |> assign(teams: Teams.all())
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
    |> assign_page_title("Teams")
    |> assign(:team, nil)
  end
end
