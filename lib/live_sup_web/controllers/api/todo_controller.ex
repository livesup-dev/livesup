defmodule LiveSupWeb.Api.TodoController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Todos
  alias LiveSup.Schemas.Todo

  def index(conn, %{"project_id" => project_id}) do
    todos = project_id |> Todos.by_project()
    render(conn, "index.json", todos: todos)
  end

  def create(conn, %{"project_id" => project_id, "todo" => todo_params}) do
    with {:ok, %Todo{} = todo} <-
           Todos.create(Map.merge(todo_params, %{"project_id" => project_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/todos/#{todo.id}")
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get!(id)

    with {:ok, %Todo{} = todo} <-
           Todos.update(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get!(id)

    with {:ok, %Todo{}} <- Todos.delete(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
