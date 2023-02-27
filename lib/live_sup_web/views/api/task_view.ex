defmodule LiveSupWeb.Api.TaskView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.{TodoView, TaskView, UserView}

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: %{todo: %Ecto.Association.NotLoaded{}} = task}) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      notes: task.notes,
      completed: task.completed,
      due_on: task.due_on,
      todo: %{
        id: task.todo_id
      },
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      notes: task.notes,
      completed: task.completed,
      due_on: task.due_on,
      todo: render_one(task.todo, TodoView, "todo.json"),
      assigned_to: render_one(task.assigned_to, UserView, "user.json"),
      created_by: render_one(task.created_by, UserView, "user.json"),
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
end
