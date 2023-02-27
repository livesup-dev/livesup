defmodule LiveSupWeb.Todo.ManageTodoLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Todos, Tasks}
  alias LiveSup.Schemas.TodoTask

  alias Palette.Components.Breadcrumb.Step

  alias LiveSupWeb.Todo.Components.{
    TodoHeaderComponent,
    TodoTaskComponent,
    TodoDrawerComponent,
    TodoAddTaskComponent
  }

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
     |> assign_breadcrumb_steps()
     |> assign_tasks()}
  end

  @impl true
  def handle_params(%{"id" => todo_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign_breadcrumb_steps()
     |> assign(:editing, nil)
     |> assign(:todo_task, nil)
     |> assign_tasks()}
  end

  def assign_breadcrumb_steps(socket) do
    socket
    |> assign(:breadcrumb_steps, [
      %Step{label: "Home", path: "/"},
      %Step{label: "Todos", path: "/todos"},
      %Step{label: socket.assigns.todo.title, path: "/todos/#{socket.assigns.todo.id}"}
    ])
  end

  defp assign_tasks(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(:tasks, Todos.get_tasks(todo_id, completed: false))
  end

  @impl true
  def handle_event(
        "add_task",
        params,
        socket
      ) do
    {:ok, task} = save_task(params, socket) |> dbg

    # LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, assign(socket, tasks: [task] ++ socket.assigns.tasks, active: %TodoTask{})}
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
    task = toggle(task_id, value)

    # delete the updated task from the list
    tasks = Enum.reject(tasks, &(&1.id == task.id))

    {:noreply, socket |> assign(:tasks, tasks)}
  end

  def toggle(task_id, "on"), do: Tasks.complete!(task_id)
  # def toggle(task_id, "off"), do: Tasks.incomplete!(task_id)

  def save_task(params, %{assigns: %{current_user: %{id: user_id}}}) do
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
