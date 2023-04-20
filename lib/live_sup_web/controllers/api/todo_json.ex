defmodule LiveSupWeb.Api.TodoJSON do
  alias LiveSupWeb.Api.ProjectJSON
  alias LiveSup.Schemas.Todo

  def index(%{todos: todos}) do
    %{data: for(todo <- todos, do: data(todo))}
  end

  def show(%{todo: todo}) do
    %{data: data(todo)}
  end

  def data(%Todo{project: %Ecto.Association.NotLoaded{} = todo}) do
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

  def data(%Todo{} = todo) do
    %{
      id: todo.id,
      title: todo.title,
      color_code: todo.color_code,
      description: todo.description,
      project: ProjectJSON.show(project: todo.project),
      inserted_at: todo.inserted_at,
      updated_at: todo.updated_at
    }
  end
end
