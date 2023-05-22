defmodule LiveSup.Core.Widgets.Todo.Handler do
  alias LiveSup.Core.Todos

  def get_data(%{"todo" => todo_id}) do
    todo = Todos.get!(todo_id)

    {:ok,
     Todos.search_tasks(%{todo: todo, completed: true, limit: 5, order_by: :updated_at_desc})}
  end
end
