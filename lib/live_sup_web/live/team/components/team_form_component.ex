defmodule LiveSupWeb.Team.Components.TeamFormComponent do
  use LiveSupWeb, :live_component
  alias LiveSup.Core.Teams

  @impl true
  def update(%{team: team} = assigns, socket) do
    changeset = Teams.change(team)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
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
    {entries, _} = uploaded_entries(socket, :avatar)
    avatar_entry = entries |> Enum.at(0)

    file_path = socket |> copy_file(avatar_entry)

    save_team(socket, socket.assigns.action, Map.put(team_params, "avatar_url", file_path))
  end

  defp copy_file(_, nil), do: nil

  defp copy_file(socket, avatar_entry) do
    Phoenix.LiveView.Upload.consume_uploaded_entry(socket, avatar_entry, fn %{path: path} ->
      dest = Path.join("priv/static/uploads", Path.basename(path))
      File.cp!(path, dest)
      Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
    end)
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
end
