defmodule LiveSupWeb.ManageTodoLive.LiveComponents.ManageTaskComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Tasks
  alias LiveSup.Schemas.TodoTask

  @impl true
  def update(%{todo_task: task} = assigns, socket) do
    changeset = Tasks.change(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo_task" => task_params}, socket) do
    changeset =
      %TodoTask{}
      |> Tasks.change(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo_task" => task_params}, socket) do
    save(socket, socket.assigns.action, task_params)
  end

  defp save(socket, :edit_task, task_params) do
    case Tasks.update(socket.assigns.todo_task, task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: ~p"/todos/#{task.todo_id}/manage")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
