defmodule LiveSupWeb.Project.ProjectBoardLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Projects, Todos}

  alias Palette.Components.Breadcrumb.Step

  on_mount(LiveSupWeb.UserLiveAuth)


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
    |> assign_defaults()
    |> assign_breadcrumb_steps()}
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Board"}
    ]

    socket
    |> assign(:steps, steps)
  end

  defp assign_page_title(socket, title) do
    socket
    |> assign(:page_title, "Projects")
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "Board")
    |> assign_page_title("Board")
    |> assign(section: :home)
  end

  @impl true
  def handle_params(%{"id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:project, Projects.get_with_dashboards!(project_id))
     |> assign_todos(project_id)}
  end

  defp assign_todos(socket, project_id) do
    socket
    |> assign(todos: Todos.by_project(project_id))
  end
end
