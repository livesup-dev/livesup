defmodule LiveSupWeb.Api.TaskJSON do
  alias LiveSupWeb.Api.{TodoJSON, UserJSON}
  alias LiveSup.Schemas.TodoTask

  def index(%{tasks: tasks}) do
    %{data: for(task <- tasks, do: data(task))}
  end

  def show(%{task: task}) do
    %{data: data(task)}
  end

  def data(%TodoTask{todo: %Ecto.Association.NotLoaded{}} = task) do
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

  def data(%Task{} = task) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      notes: task.notes,
      completed: task.completed,
      due_on: task.due_on,
      todo: TodoJSON.show(task.todo),
      assigned_to: UserJSON.show(user: task.assigned_to),
      created_by: UserJSON.show(user: task.created_by),
      inserted_at: task.inserted_at,
      updated_at: task.updated_at
    }
  end
end
