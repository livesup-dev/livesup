defmodule LiveSupWeb.Api.TodoView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.{ProjectView, TodoView}

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: %{project: %Ecto.Association.NotLoaded{}} = todo}) do
    %{
      id: todo.id,
      title: todo.title,
      color_code: todo.color_code,
      description: todo.description,
      project: %{
        id: todo.project_id
      },
      inserted_at: todo.inserted_at,
      updated_at: todo.updated_at
    }
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      title: todo.title,
      color_code: todo.color_code,
      description: todo.description,
      project: render_one(todo.project, ProjectView, "project.json"),
      inserted_at: todo.inserted_at,
      updated_at: todo.updated_at
    }
  end
end
