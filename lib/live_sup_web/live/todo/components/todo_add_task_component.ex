defmodule LiveSupWeb.Todo.Components.TodoAddTaskComponent do
  use LiveSupWeb, :component

  alias LiveSupWeb.Live.Todo.Components.ColorsComponent

  attr(:todo, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class="border-b border-slate-150 py-3 dark:border-navy-500">
      <div class="flex h-8 items-center justify-between">
        <form phx-submit="add_task" class="flex justify-center">
          <.hidden_input value={@todo.id} name="todo_id" />
          <input
            type="text"
            name="title"
            placeholder="What needs to be done?"
            autofocus="autofocus"
            class="w-96 text-xl placeholder-blue-400 py-2 px-5 outline outline-1 outline-slate-100 focus:outline-blue-200 focus:outline-2"
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
