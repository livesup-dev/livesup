defmodule LiveSupWeb.WelcomeLive do
  use LiveSupWeb, :live_view

  import LiveSupWeb.Live.AuthHelper
  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.Team

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     assign(socket,
       current_user: current_user,
       teams: Teams.all
     )}
  end
end
