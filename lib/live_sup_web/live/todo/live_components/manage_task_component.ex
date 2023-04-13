defmodule LiveSupWeb.ManageTodoLive.LiveComponents.ManageTaskComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Tasks
  alias LiveSup.Schemas.TodoTask
  alias LiveSupWeb.Live.Todo.Components.TaskDetails.{TaskComponent, CommentsComponent}

  @impl true
  def update(%{task: task} = assigns, socket) do
    # changeset = Tasks.change(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:task, task)
     |> stream(:comments, fetch_comments(task))
     |> assign(:error, nil)
     |> assign(:editing_task, false)}
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

  def handle_event(
        "add_comment",
        %{"body" => body},
        %{assigns: %{task: task, current_user: current_user}} = socket
      ) do
    case Tasks.add_comment(task, current_user, body) do
      {:ok, comment} ->
        {:noreply, stream_insert(socket, :comments, comment)}

      {:error, error} ->
        {:noreply, socket |> assign(:error, error)}
    end
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

  defp fetch_comments(%{id: nil}), do: []

  defp fetch_comments(%{id: _id} = task) do
    task
    |> Tasks.get_comments()
  end
end
