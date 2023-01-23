defmodule LiveSupWeb.Todo.ManageTodoLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Todos, Tasks}
  alias LiveSup.Schemas.TodoTask

  alias Palette.Components.Breadcrumb.Step
  alias LiveSupWeb.Todo.Components.{TodoHeaderComponent, TodoTaskComponent, TodoDrawerComponent}

  on_mount(LiveSupWeb.UserLiveAuth)

  @impl true
  def mount(%{"id" => todo_id}, _session, socket) do
    {:ok,
     socket
     |> assign_defaults()
     |> assign_tasks(todo_id)}
  end

  @impl true
  def handle_params(%{"id" => todo_id, "task_id" => task_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign(:todo_task, Tasks.get!(task_id))
     |> assign(:editing, nil)
     |> assign_tasks(task_id)}
  end

  @impl true
  def handle_params(%{"id" => todo_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign(:editing, nil)
     |> assign(:todo_task, nil)
     |> assign_tasks(todo_id)}
  end

  defp assign_tasks(socket, todo_id) do
    socket
    |> assign(:tasks, Todos.get_tasks(todo_id))
  end

  @impl true
  def handle_event("create", %{"description" => description, "todo_id" => todo_id}, socket) do
    Todos.add_task(%{
      description: description,
      todo_id: todo_id,
      created_by_id: socket.assigns.current_user.id
    })

    # LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, assign(socket, tasks: Todos.get_tasks(todo_id), active: %TodoTask{})}
  end

  @impl true
  def handle_event("toggle", %{"id" => task_id, "value" => value}, socket) do
    task =
      if value do
        Tasks.complete!(task_id)
      else
        Tasks.incomplete!(task_id)
      end

    socket = assign(socket, tasks: Todos.get_tasks(task.todo_id), active: %TodoTask{})
    # LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "update", payload: %{tasks: items}}, socket) do
    {:noreply, assign(socket, tasks: items)}
  end

  defp assign_defaults(socket) do
    socket
    |> assign(title: "ToDo")
    |> assign(section: :home)
    |> assign(selected_task: %TodoTask{})
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
