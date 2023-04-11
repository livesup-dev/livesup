defmodule LiveSupWeb.WelcomeLive do
  use LiveSupWeb, :live_view

  import LiveSupWeb.Live.AuthHelper
  alias LiveSup.Core.{Teams, Users}
  alias LiveSup.Schemas.{Team, User}

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:section, :home)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :home, _) do
    socket |> redirect(to: "/welcome/teams")
  end

  defp apply_action(socket, :teams, _) do
    %{id: user_id} = socket.assigns.current_user

    user = user_id |> Users.get!()

    changeset = User.update_changeset(user, %{})

    socket
    |> assign(:teams, Teams.all())
    |> assign(:changeset, changeset)
  end

  defp apply_action(socket, :thank_you, _) do
    socket
  end

  defp apply_action(socket, :location, _) do
    %{id: user_id} = socket.assigns.current_user

    user = user_id |> Users.get!()

    changeset = User.update_changeset(user, %{})

    socket
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    associate_teams(socket, user_params)
  end

  @impl true
  def handle_event("save_location", %{"user" => user_params}, socket) do
    %{
      "address_country" => country,
      "address_lat" => lat,
      "address_lng" => lng,
      "address_state" => state,
      "id" => user_id
    } = user_params

    location = %{
      country: country,
      lat: lat,
      lng: lng,
      state: state
    }

    save_location(user_id, location, socket)
  end

  defp save_location(user_id, %{lat: lat, lng: lng} = location, socket) do
    {:ok, %{time_zone_id: time_zone_id}} = LiveSup.Core.Utils.get_timezone_from_location(lat, lng)

    data = Map.put(location, :timezone, time_zone_id)

    Users.get!(user_id)
    |> Users.update!(%{location: data})
    |> Users.onboard!()

    {:noreply,
     socket
     |> put_flash(:info, "Location updated successfully")
     |> push_redirect(to: ~p"/welcome/thank-you")}
  end

  defp associate_teams(socket, %{"id" => user_id, "teams" => teams}) do
    teams
    |> Enum.each(fn team_id ->
      Teams.add_member(%Team{id: team_id}, %User{id: user_id})
    end)

    {:noreply,
     socket
     |> put_flash(:info, "Teams added successfully")
     # We need to do a redirection so the google map can actually be loaded.
     |> redirect(to: "/welcome/location")}
  end
end
