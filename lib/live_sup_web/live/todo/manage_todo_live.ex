defmodule LiveSupWeb.Todo.ManageTodoLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Todos, Tasks, Favorites}
  alias LiveSup.Schemas.TodoTask

  alias LiveSupWeb.Todo.Live.Components.BindKeyEventLoading
  alias Palette.Components.Breadcrumb.Step

  alias LiveSupWeb.Todo.Components.{
    TodoHeaderComponent,
    TaskRowComponent,
    TodoAddTaskComponent
  }

  @section :projects

  @impl true
  def mount(%{"id" => todo_id}, _session, socket) do
    {:ok,
     socket
     |> assign_todo(todo_id)
     |> assign_defaults()
     |> assign_tasks()}
  end

  @impl true
  def mount(%{"task_id" => task_id}, _session, socket) do
    task = Tasks.get!(task_id)

    {:ok,
     socket
     |> assign_todo(task.todo_id)
     |> assign_defaults()
     |> assign(:selected_task, task)
     |> assign_tasks()}
  end

  @impl true
  def handle_params(%{"task_id" => task_id}, _, socket) do
    task = Tasks.get!(task_id)

    {:noreply,
     socket
     |> assign(:selected_task, task)
     |> assign(:todo, Todos.get!(task.todo_id))
     |> assign_breadcrumb_steps()
     |> assign(:drawer_class, "show")
     |> assign(:editing_task, false)}
  end

  @impl true
  def handle_params(%{"id" => todo_id}, _, socket) do
    {:noreply,
     socket
     |> assign_todo(todo_id)
     |> assign_breadcrumb_steps()
     |> assign(:editing, nil)
     |> assign(:todo_task, nil)}
  end

  def assign_todo(%{assigns: %{current_user: current_user}} = socket, todo_id) do
    todo = Todos.get!(todo_id)

    socket
    |> assign(:todo, todo)
    |> assign(:project, todo.project)
    |> assign(:favorite, Favorites.exists?(current_user, todo))
  end

  def assign_breadcrumb_steps(%{assigns: %{project: project}} = socket) do
    socket
    |> assign(:breadcrumb_steps, [
      %Step{label: "Home", path: "/"},
      %Step{label: "Projects", path: "/projects"},
      %Step{label: "#{project.name}'s board", path: "/projects/#{project.id}/board"},
      %Step{label: "Tasks"}
    ])
  end

  defp assign_tasks(%{assigns: %{todo: _todo}} = socket), do: assign_tasks(socket, "")

  defp assign_tasks(%{assigns: %{todo: todo}} = socket, query) do
    open_tasks = Todos.search_tasks(todo: todo, query: query, completed: false)
    completed_tasks = Todos.search_tasks(todo: todo, query: query, completed: true)

    socket
    |> stream(:completed_tasks, completed_tasks, reset: true)
    |> stream(:tasks, open_tasks, reset: true)
    |> assign(:completed_tasks_count, length(completed_tasks))
    |> assign(:open_tasks_count, length(open_tasks))
    |> assign(:query, query)
  end

  # defp assign_completed_tasks(%{assigns: %{todo: %{id: todo_id}}} = socket) do
  #   completed_tasks = Todos.tasks(todo_id, completed: true)

  #   socket
  #   |> stream(:completed_tasks, completed_tasks)
  #   |> assign(:completed_tasks_count, length(completed_tasks))
  # end

  def handle_event(
        "search",
        %{"key" => _key, "value" => value},
        %{assigns: %{todo: _todo}} = socket
      ) do
    {:noreply, assign_tasks(socket, value)}
  end

  @impl true
  def handle_event(
        "add_task",
        params,
        %{assigns: %{open_tasks_count: open_tasks_count}} = socket
      ) do
    {:ok, task} = save_task(params, socket)

    {:noreply,
     socket
     |> stream_insert(:tasks, task)
     |> assign(:active, %TodoTask{})
     |> assign(:open_tasks_count, open_tasks_count + 1)}
  end

  def handle_event("select_task", %{"id" => task_id}, socket) do
    {:noreply,
     socket
     |> assign(:selected_task, Tasks.get!(task_id))
     |> assign(:editing_task, false)
     |> push_patch(to: ~p"/todos/#{socket.assigns.todo.id}/tasks/#{task_id}/edit")}
  end

  @impl true
  def handle_event(
        "toggle",
        %{"id" => task_id, "value" => value},
        %{assigns: %{completed_tasks_count: completed_tasks_count}} = socket
      ) do
    task = toggle(task_id, value)

    {:noreply,
     socket
     |> stream_insert(:completed_tasks, task)
     |> stream_delete(:tasks, task)
     |> assign(:completed_tasks_count, completed_tasks_count + 1)}
  end

  @impl true
  def handle_event(
        "favorite",
        _params,
        %{assigns: %{todo: todo, current_user: current_user}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:favorite, Favorites.toggle(current_user, todo))}
  end

  def toggle(task_id, "on"), do: Tasks.complete!(task_id)
  # def toggle(task_id, "off"), do: Tasks.incomplete!(task_id)

  def save_task(params, %{assigns: %{current_user: %{id: user_id}}}) do
    Todos.add_task(Map.put(params, "created_by_id", user_id))
  end

  # @impl true
  # def handle_info(%{event: "update", payload: %{tasks: items}}, socket) do
  #   {:noreply, assign(socket, tasks: items)}
  # end

  defp assign_defaults(%{assigns: %{todo: %{id: todo_id, title: title}}} = socket) do
    socket
    |> assign(title: title)
    |> assign(section: @section)
    |> assign(page_title: "#{title} - Todo")
    |> assign(:error, nil)
    |> assign(:editing_task, false)
    |> assign(selected_task: %TodoTask{todo_id: todo_id})
    |> assign(:completed_tasks, [])
    |> assign(:query, "")
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
