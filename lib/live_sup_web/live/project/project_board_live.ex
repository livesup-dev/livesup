defmodule LiveSupWeb.Project.ProjectBoardLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Schemas.Dashboard

  alias LiveSup.Core.{Projects, Todos, Tasks}
  alias LiveSup.Schemas.Dashboard

  alias Palette.Components.Breadcrumb.Step

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(%{"id" => project_id}, _session, socket) do
    {:ok,
     socket
     |> assign_project(project_id)
     |> assign_defaults()
     |> assign_todos()
     |> assign_breadcrumb_steps()}
  end

  defp assign_project(socket, project_id) do
    socket
    |> assign(:project, Projects.get_with_dashboards!(project_id))
  end

  defp assign_todos(%{assigns: %{project: %{id: project_id}}} = socket) do
    socket
    |> assign(todos: Todos.by_project(project_id))
  end

  defp assign_breadcrumb_steps(socket) do
    steps = [
      %Step{label: "Home", path: "/"},
      %Step{label: "Projects", path: "/projects"},
      %Step{label: "Board"}
    ]

    socket
    |> assign(:breadcrumb_steps, steps)
  end

  defp assign_page_title(socket, title) do
    socket
    |> assign(:page_title, title)
  end

  defp assign_defaults(%{assigns: %{project: %{name: name}}} = socket) do
    socket
    |> assign(title: name)
    |> assign_page_title("#{name} - Project")
    |> assign(section: :projects)
  end

  def percentage_completed_tasks(todo) do
    case todo.completed_tasks_count do
      0 ->
        0

      _ ->
        todo.completed_tasks_count / (todo.completed_tasks_count + todo.open_tasks_count) * 100
    end
  end

  @impl true
  def handle_params(%{"id" => project_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:project, Projects.get_with_dashboards!(project_id))}
  end

  defp open_tasks(%{id: id}) do
    Tasks.by_todo(id, limit: 3, completed: false)
  end
end
