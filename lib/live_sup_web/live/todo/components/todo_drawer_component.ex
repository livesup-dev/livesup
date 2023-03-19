defmodule LiveSupWeb.Todo.Components.TodoDrawerComponent do
  use LiveSupWeb, :component
  alias Phoenix.LiveView.JS
  alias LiveSupWeb.Live.Todo.Components.TaskDetails.TaskComponent

  attr(:task, :map, required: true)
  attr(:editing_task, :boolean, default: false)
  attr(:error, :any, default: nil)
  attr(:drawer_class, :string, default: "hidden")

  def render(assigns) do
    ~H"""
    <div id="edit-todo-drawer" class={"drawer drawer-right #{@drawer_class}"}>
      <div class="drawer-overlay fixed inset-0 z-[100]  bg-slate-900/60"></div>
      <div class="drawer-content fixed right-0 top-0 z-[101]  h-full w-2/4">
        <div class="flex h-full w-full flex-col bg-white dark:bg-navy-700">
          <div class="flex h-14 items-center justify-between bg-slate-150 p-4 dark:bg-navy-800">
            <h3 class="text-base font-medium text-slate-700 dark:text-navy-100">
              Edit Todo
            </h3>
            <div class="-mr-1.5 flex items-center space-x-2.5">
              <input
                data-tooltip="Mark as Completed"
                data-tooltip-theme="primary"
                class="form-checkbox is-basic h-5 w-5 rounded-full border-slate-400/70 checked:border-primary checked:bg-primary hover:border-primary focus:border-primary dark:border-navy-400 dark:checked:border-accent dark:checked:bg-accent dark:hover:border-accent dark:focus:border-accent"
                type="checkbox"
              />
              <div class="flex">
                <button class="btn h-7 w-7 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-4.5 w-4.5"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="1.5"
                      d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
                    />
                  </svg>
                </button>
                <button
                  id="close"
                  phx-click={JS.toggle(to: "#edit-todo-drawer")}
                  class="btn h-7 w-7 rounded-full p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-4.5 w-4.5"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>
          </div>
          <TaskComponent.render task={@task} error={@error} editing_task={@editing_task} />
        </div>
      </div>
    </div>
    """
  end
end
