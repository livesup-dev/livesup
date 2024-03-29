defmodule LiveSupWeb.Team.Components.TeamFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.Teams

  @impl true
  def update(%{team: team} = assigns, socket) do
    changeset = Teams.change(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign(:error, nil)}
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    changeset =
      socket.assigns.team
      |> Teams.change(team_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"team" => team_params}, socket) do
    save_team(socket, socket.assigns.action, team_params)
  end

  defp save_team(socket, :new, team_params) do
    case Teams.create(team_params) do
      {:ok, team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team creted successfully")
         |> push_redirect(to: ~p"/teams/#{team.id}/members")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_team(socket, :edit, team_params) do
    case Teams.update(socket.assigns.team, team_params) do
      {:ok, team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team updated successfully")
         |> push_redirect(to: ~p"/teams/#{team.id}/members")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
