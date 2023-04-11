defmodule LiveSupWeb.Api.TaskController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.{Todos, Tasks}
  alias LiveSup.Schemas.TodoTask

  def index(conn, %{"todo_id" => todo_id}) do
    tasks = todo_id |> Tasks.by_todo()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"todo_id" => todo_id, "task" => task_params}) do
    # We need to make sure the todo exists
    with {:ok, %TodoTask{} = task} <-
           Todos.add_task(Map.merge(task_params, %{"todo_id" => todo_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/tasks/#{task.id}")
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get!(id)

    with {:ok, %TodoTask{} = task} <-
           Tasks.update(task, task_params) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Tasks.get!(id)

    with {:ok, %TodoTask{}} <- Tasks.delete(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
