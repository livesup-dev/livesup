defmodule LiveSupWeb.Live.Team.Components.MemberFormComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.{Teams, Users}
  alias LiveSup.Schemas.User

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_defaults()
     |> assign_form()}
  end

  def assign_defaults(socket) do
    socket
    |> assign(:error, nil)
  end

  def assign_form(socket) do
    changeset = %User{password: User.random_password()} |> Users.change()

    socket
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("save", %{"user" => member}, %{assigns: %{team: team}} = socket) do
    case Users.create(member) do
      {:ok, user} ->
        case Teams.add_member(team, user) do
          {:ok, team_member} ->
            {:noreply, socket |> stream_insert(:members, team_member)}

          {:error, changeset} ->
            {:noreply, socket |> assign_errors(changeset)}
        end

      {:error, changeset} ->
        {:noreply, socket |> assign_errors(changeset)}
    end
  end

  def assign_errors(socket, changeset) do
    socket
    |> assign(:error, changeset.errors |> Enum.map(&manage_key/1))
  end

  defp manage_key({key, {value, _}}) do
    "#{key} #{value}"
  end
end
