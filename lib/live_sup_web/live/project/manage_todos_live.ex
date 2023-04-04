defmodule LiveSupWeb.Project.ManageTodosLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Projects
  alias Palette.Components.Breadcrumb.Step

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(%{"id" => project_id}, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_project(project_id)
     |> assign_breadcrumb_steps()}
  end

  def assign_project(socket, project_id) do
    socket
    |> assign(:project, Projects.get_with_todos!(project_id))
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "ToDo")
    |> assign(section: :home)
  end

  def assign_breadcrumb_steps(
        %{assigns: %{project: %{name: project_name, id: project_id}}} = socket
      ) do
    steps = [
      %Step{label: "Home", path: "/"},
      %Step{label: "Projects", path: "/projects"},
      %Step{label: "Board", path: "/projects/#{project_id}/board"},
      %Step{label: project_name}
    ]

    socket
    |> assign(:breadcrumb_steps, steps)
  end
end
