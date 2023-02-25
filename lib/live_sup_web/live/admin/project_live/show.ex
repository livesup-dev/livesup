defmodule LiveSupWeb.Admin.ProjectLive.Show do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:section, :home)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:project, Projects.get!(id))}
  end

  defp page_title(:show), do: "Show Project"
  defp page_title(:edit), do: "Edit Project"
end
