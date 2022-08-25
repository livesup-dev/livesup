defmodule LiveSupWeb.Project.ProjectBoardLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Projects, Todos}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
