defmodule LiveSupWeb.ManageTodoLive.LiveComponents.ManageTaskComponent do
  use LiveSupWeb, :live_component

  alias LiveSup.Core.Tasks
  alias LiveSupWeb.Live.Todo.Components.TaskDetails.{TaskComponent, CommentsComponent}

  @impl true
  def update(%{task: task} = assigns, socket) do
    # changeset = Tasks.change(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:task, task)
     |> assign_comments()
     |> assign(:error, nil)
     |> assign(:editing_task, false)}
  end

  def assign_comments(%{assigns: %{comments: comments}} = socket) when is_list(comments),
    do: socket

  def assign_comments(%{assigns: %{task: task}} = socket) do
    socket
    |> stream(:comments, fetch_comments(task))
  end

  @impl true
  def handle_event("edit_mode", %{"mode" => "true"}, socket) do
    {:noreply, assign(socket, editing_task: true)}
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

  def handle_event(
        "save",
        params,
        %{assigns: %{task: selected_task}} = socket
      ) do
    {:ok, updated_task} =
      selected_task
      |> Tasks.update(params)

    {:noreply, socket |> assign(:task, updated_task) |> assign(:editing_task, false)}
  end

  defp fetch_comments(%{id: nil}), do: []

  defp fetch_comments(%{id: _id} = task) do
    task
    |> Tasks.get_comments()
  end
end
