defmodule LiveSupWeb.Admin.TeamLive.Show do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.Team

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:section, :home)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:team, Teams.get!(id))}
  end

  defp page_title(:show), do: "Show Team"
  defp page_title(:edit), do: "Edit Team"
end
