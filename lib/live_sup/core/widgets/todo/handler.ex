defmodule LiveSup.Core.Widgets.Todo.Handler do
  alias LiveSup.Core.Todos

  def get_data(%{"todo" => todo_id}) do
    {:ok,
     todo_id
     |> Todos.tasks()}
  end
end
