defmodule LiveSupWeb.Admin.ProjectLive.Index do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:projects, list_projects())
     |> assign(:section, :home)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, Projects.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project = Projects.get!(id)
    {:ok, _} = Projects.delete(project)

    {:noreply, assign(socket, :projects, list_projects())}
  end

  defp list_projects do
    Projects.all()
  end
end
