defmodule LiveSupWeb.Todo.Components.TodoAddTaskComponent do
  use LiveSupWeb, :component

  alias LiveSupWeb.Live.Todo.Components.ColorsComponent

  attr(:todo, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class="border-b border-slate-150 py-3 dark:border-navy-500">
      <div class="flex items-center space-x-2 sm:space-x-3">
        <form phx-submit="add_task" class="flex justify-center">
          <.hidden_input value={@todo.id} name="todo_id" />
          <input
            type="text"
            name="title"
            placeholder="What needs to be done?"
            autofocus=""
            class="w-96 text-xl placeholder-blue-400 py-2 px-5 outline-blue-300"
          />
          <button
            type="submit"
            class="text-xl text-blue-100 placeholder-blue-400 py-2 pr-5 pl-4 bg-blue-500 rounded-r-full"
          >
          </button>
        </form>
        <ColorsComponent.render />
      </div>
    </div>
    """
  end
end
