defmodule LiveSupWeb.Todo.Components.TodoAddTaskComponent do
  use LiveSupWeb, :component

  alias LiveSupWeb.Live.Todo.Components.ColorsComponent

  attr(:todo, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class="border-b border-slate-150 py-3 dark:border-navy-500">
      <div class="items-center md:flex md:justify-between">
        <form phx-submit="add_task" class="my-4 md:my-0 md:flex md:justify-center">
          <.hidden_input value={@todo.id} name="todo_id" />

          <label class="relative flex">
            <input
              type="text"
              name="title"
              placeholder="What needs to be done?"
              class="form-input peer w-full md:w-96 rounded-lg border border-slate-300 bg-transparent px-3 py-2 pr-9 placeholder:text-slate-400/70 hover:border-slate-400 focus:border-primary dark:border-navy-450 dark:hover:border-navy-400 dark:focus:border-accent"
            />
            <div class="pointer-events-none absolute right-0 flex h-full w-10 items-center justify-center text-slate-400 peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                class="w-4.5 h-4.5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
            </div>
          </label>
        </form>
        <ColorsComponent.render />
      </div>
    </div>
    """
  end
end
