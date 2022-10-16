defmodule LiveSupWeb.Todo.ManageTaskLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.Tasks

  @impl true
  def mount(%{"id" => task_id}, _session, socket) do
    {:ok, socket |> assign_task(task_id)}
  end

  @impl true
  def handle_params(%{"id" => task_id}, _, socket) do
    {:noreply,
     socket
     |> assign_task(task_id)}
  end

  defp assign_task(socket, task_id) do
    socket
    |> assign(:task, Tasks.get_with_comments!(task_id))
  end
end
