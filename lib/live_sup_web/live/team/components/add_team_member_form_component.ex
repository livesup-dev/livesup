defmodule LiveSupWeb.Team.Components.AddTeamMemberFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.{Teams, Users}
  alias LiveSup.Schemas.{User, Team}

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:users, [])}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => ""}}, socket) do
    {:noreply, socket |> assign(:users, [])}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    users = Users.search(%{value: query, not_in_team: socket.assigns.team.id})

    {:noreply,
     socket
     |> assign(:users, users)}
  end

  @impl true
  def handle_event("add_member", %{"team-id" => team_id, "user-id" => user_id}, socket) do
    {:ok, _team_member} = Teams.add_member(%Team{id: team_id}, %User{id: user_id})
    {:noreply, socket}
  end
end
