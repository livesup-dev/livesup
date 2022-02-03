defmodule LiveSupWeb.Project.ProjectLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects
  alias LiveSup.Schemas.Project

  @impl true
  def mount(_params, session, socket) do
    current_user = get_current_user(session, socket)

    {:ok,
     socket
     |> assign_title()
     |> assign_current_user(current_user)
     |> assign_page_title("Projects")
     |> assign_projects(current_user)
     |> assign(:project, nil)
     |> assign_section()}
  end

  defp assign_page_title(socket, page_title) do
    socket
    |> assign(page_title: page_title)
  end

  defp assign_current_user(socket, current_user) do
    socket
    |> assign(current_user: current_user)
  end

  defp assign_title(socket) do
    socket
    |> assign(title: "Projects")
  end

  defp assign_projects(socket, user) do
    projects = user |> Projects.by_user()

    socket
    |> assign(projects: projects)
  end

  defp assign_section(socket) do
    socket
    |> assign(section: :project_listing)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign_page_title("New project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign_page_title("Projects")
    |> assign(:project, nil)
  end
end
