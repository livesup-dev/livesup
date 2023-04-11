defmodule LiveSupWeb.Todo.ManageTodoLive do
  use LiveSupWeb, :live_view

  alias LiveSup.Core.{Todos, Tasks}
  alias LiveSup.Schemas.TodoTask

  alias Palette.Components.Breadcrumb.Step

  alias LiveSupWeb.Todo.Components.{
    TodoHeaderComponent,
    TaskRowComponent,
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

  @impl true
  def handle_params(%{"id" => todo_id, "task_id" => task_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:todo, Todos.get!(todo_id))
     |> assign(:selected_task, Tasks.get!(task_id))
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
     |> assign(:todo_task, nil)
     |> assign_tasks()
     |> assign_completed_tasks()}
  end

  def assign_todo(socket, todo_id) do
    todo = Todos.get!(todo_id)

    socket
    |> assign(:todo, todo)
    |> assign(:project, todo.project)
  end

  def assign_breadcrumb_steps(%{assigns: %{todo: todo, project: project}} = socket) do
    socket
    |> assign(:breadcrumb_steps, [
      %Step{label: "Home", path: "/"},
      %Step{label: "Projects", path: "/projects"},
      %Step{label: "#{project.name}'s board", path: "/projects/#{project.id}/board"},
      %Step{label: todo.title, path: "/todos/#{todo.id}"}
    ])
  end

  defp assign_tasks(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(:tasks, Todos.get_tasks(todo_id, completed: false))
  end

  defp assign_completed_tasks(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(:completed_tasks, Todos.get_tasks(todo_id, completed: true))
  end

  @impl true
  def handle_event(
        "add_task",
        params,
        socket
      ) do
    {:ok, task} = save_task(params, socket)

    # LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, assign(socket, tasks: [task] ++ socket.assigns.tasks, active: %TodoTask{})}
  end

  def handle_event(
        "save",
        %{"id" => _id} = params,
        %{assigns: %{selected_task: _selected_task, tasks: tasks}} = socket
      ) do
    {:ok, updated_task} = save_task(params, socket)

    # delete the updated task from the list
    tasks = Enum.reject(tasks, &(&1.id == updated_task.id))

    # add the updated task to the list
    tasks = tasks ++ [updated_task]

    {:noreply, assign(socket, tasks: tasks, selected_task: %TodoTask{})}
  end

  def handle_event("select_task", %{"id" => task_id}, socket) do
    {:noreply,
     socket
     |> assign(:selected_task, Tasks.get!(task_id))
     |> assign(:editing_task, false)
     |> push_patch(to: ~p"/todos/#{socket.assigns.todo.id}/tasks/#{task_id}/edit")}
  end

  def handle_event("edit_mode", %{"mode" => "true"}, socket) do
    {:noreply, assign(socket, editing_task: true)}
  end

  def handle_event(
        "add_comment",
        %{"body" => body},
        %{assigns: %{selected_task: task, current_user: current_user}} = socket
      ) do
    Tasks.add_comment(task, current_user, body)
    {:noreply, socket}
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

  def save_task(%{"id" => id} = params, %{assigns: %{selected_task: selected_task}})
      when is_binary(id) do
    selected_task
    |> Tasks.update(params)
  end

  def save_task(params, %{assigns: %{current_user: %{id: user_id}}}) do
    Todos.add_task(Map.put(params, "created_by_id", user_id))
  end

  @impl true
  def handle_info(%{event: "update", payload: %{tasks: items}}, socket) do
    {:noreply, assign(socket, tasks: items)}
  end

  defp assign_defaults(%{assigns: %{todo: %{id: todo_id}}} = socket) do
    socket
    |> assign(title: "ToDo")
    |> assign(section: @section)
    |> assign(page_title: "Manage ToDo")
    |> assign(:error, nil)
    |> assign(:drawer_class, "hidden")
    |> assign(:editing_task, false)
    |> assign(selected_task: %TodoTask{todo_id: todo_id})
    |> assign(:completed_tasks, [])
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
