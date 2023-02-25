defmodule LiveSupWeb.Admin.TeamLive.Index do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.Team

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:teams, list_teams())
     |> assign(:section, :home)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, Teams.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, %Team{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    team = Teams.get!(id)
    {:ok, _} = Teams.delete(team)

    {:noreply, assign(socket, :teams, list_teams())}
  end

  defp list_teams do
    Teams.all()
  end
end
