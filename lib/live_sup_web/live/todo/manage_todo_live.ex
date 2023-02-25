defmodule LiveSupWeb.Todo.ManageTodoLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Todos, Tasks}
  alias LiveSup.Schemas.TodoTask

  alias Palette.Components.Breadcrumb.Step
  alias LiveSupWeb.Todo.Components.{TodoHeaderComponent, TodoTaskComponent, TodoDrawerComponent}

  on_mount(LiveSupWeb.UserLiveAuth)

  @section :todo

  @impl true
  def mount(%{"id" => todo_id}, _session, socket) do
    {:ok,
     socket
     |> assign_todo(todo_id)
     |> assign_defaults()
     |> assign_tasks()}
  end

  def assign_todo(socket, todo_id) do
    socket
    |> assign(:todo, Todos.get!(todo_id))
  end

  @impl true
  def handle_params(%{"id" => todo_id, "task_id" => task_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign(:todo_task, Tasks.get!(task_id))
     |> assign(:editing, nil)
     |> assign_tasks()}
  end

  @impl true
  def handle_params(%{"id" => todo_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign(:editing, nil)
     |> assign(:todo_task, nil)
     |> assign_tasks()}
  end

  defp assign_tasks(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(:tasks, Todos.get_tasks(todo_id))
  end

  @impl true
  def handle_event(
        "create",
        params,
        socket
      ) do
    {:ok, task} = save_task(params, socket)

    # LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, assign(socket, tasks: socket.assigns.task ++ [task], active: %TodoTask{})}
  end

  def handle_event(
        "save",
        %{"id" => id} = params,
        %{assigns: %{selected_task: selected_task, tasks: tasks}} = socket
      ) do
    {:ok, updated_task} = save_task(params, socket)

    # delete the updated task from the list
    tasks = Enum.reject(tasks, &(&1.id == updated_task.id))

    # add the updated task to the list
    tasks = tasks ++ [updated_task]

    {:noreply, assign(socket, tasks: tasks, selected_task: %TodoTask{})}
  end

  def handle_event("select_task", %{"id" => task_id} = task, socket) do
    {:noreply, assign(socket, selected_task: Tasks.get!(task_id))}
  end

  @impl true
  def handle_event(
        "toggle",
        %{"id" => task_id, "value" => value},
        %{assigns: %{tasks: tasks}} = socket
      ) do
    task =
      if value do
        Tasks.complete!(task_id)
      else
        Tasks.incomplete!(task_id)
      end

    # TODO: This is a hack to get the task to update in the list
    socket = assign(socket, tasks: tasks ++ [task], active: %TodoTask{})
    {:noreply, socket}
  end

  def save_task(%{"id" => ""} = params, %{assigns: %{current_user: %{id: user_id}}}) do
    Todos.add_task(Map.put(params, "created_by_id", user_id))
  end

  def save_task(%{"id" => _} = params, %{assigns: %{selected_task: %{id: selected_task}}}) do
    selected_task
    |> Tasks.update(params)
  end

  @impl true
  def handle_info(%{event: "update", payload: %{tasks: items}}, socket) do
    {:noreply, assign(socket, tasks: items)}
  end

  defp assign_defaults(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(title: "ToDo")
    |> assign(section: @section)
    |> assign(:error, nil)
    |> assign(selected_task: %TodoTask{todo_id: todo_id})
  end

  def completed?(%{completed: true}), do: "completed"
  def completed?(%{completed: false}), do: ""

  def checked?(item) do
    item.completed
  end

  def row_class(%{completed: false}) do
    "odd:bg-blue-100 even:bg-blue-50 transition duration-300"
  end

  def row_class(%{completed: true}) do
    "bg-green-100 line-through"
  end
end
