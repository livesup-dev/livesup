defmodule LiveSupWeb.Todo.Components.TodoHeaderComponent do
  use LiveSupWeb, :component

  attr(:todo, :map, required: true)
  attr(:completed_tasks_count, :integer, required: true)
  attr(:open_tasks_count, :integer, required: true)
  attr(:query, :string, default: "")
  attr(:target, :string, default: "")

  def render(assigns) do
    ~H"""
    <div class="py-5">
      <div class="flex items-center justify-between">
        <div class="flex items-start space-x-2">
          <label class="relative flex">
            <input
              class="form-input peer h-9 w-full rounded-lg border border-slate-300 bg-transparent px-3 py-2 pl-9 placeholder:text-slate-400/70 hover:z-10 hover:border-slate-400 focus:z-10 focus:border-primary dark:border-navy-450 dark:hover:border-navy-400 dark:focus:border-accent"
              type="text"
              placeholder="Search tasks..."
              name="query"
              value={@query}
              autocomplete="off"
              phx-keyup={JS.push("search", target: @target, loading: @target)}
              phx-debounce="500"
              id="query"
            />
            <span class="pointer-events-none absolute flex h-full w-10 items-center justify-center text-slate-400 peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-4.5 w-4.5 transition-colors duration-200"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path d="M3.316 13.781l.73-.171-.73.171zm0-5.457l.73.171-.73-.171zm15.473 0l.73-.171-.73.171zm0 5.457l.73.171-.73-.171zm-5.008 5.008l-.171-.73.171.73zm-5.457 0l-.171.73.171-.73zm0-15.473l-.171-.73.171.73zm5.457 0l.171-.73-.171.73zM20.47 21.53a.75.75 0 101.06-1.06l-1.06 1.06zM4.046 13.61a11.198 11.198 0 010-5.115l-1.46-.342a12.698 12.698 0 000 5.8l1.46-.343zm14.013-5.115a11.196 11.196 0 010 5.115l1.46.342a12.698 12.698 0 000-5.8l-1.46.343zm-4.45 9.564a11.196 11.196 0 01-5.114 0l-.342 1.46c1.907.448 3.892.448 5.8 0l-.343-1.46zM8.496 4.046a11.198 11.198 0 015.115 0l.342-1.46a12.698 12.698 0 00-5.8 0l.343 1.46zm0 14.013a5.97 5.97 0 01-4.45-4.45l-1.46.343a7.47 7.47 0 005.568 5.568l.342-1.46zm5.457 1.46a7.47 7.47 0 005.568-5.567l-1.46-.342a5.97 5.97 0 01-4.45 4.45l.342 1.46zM13.61 4.046a5.97 5.97 0 014.45 4.45l1.46-.343a7.47 7.47 0 00-5.568-5.567l-.342 1.46zm-5.457-1.46a7.47 7.47 0 00-5.567 5.567l1.46.342a5.97 5.97 0 014.45-4.45l-.343-1.46zm8.652 15.28l3.665 3.664 1.06-1.06-3.665-3.665-1.06 1.06z">
                </path>
              </svg>
            </span>
          </label>
          <div class="flex space-x-2">
            <div
              x-data="usePopper({placement:'bottom-start',offset:4})"
              @click.outside="isShowPopper && (isShowPopper = false)"
              class="inline-flex"
            >
              <button
                class="btn space-x-2 bg-slate-150 font-medium text-slate-800 hover:bg-slate-200 focus:bg-slate-200 active:bg-slate-200/80 dark:bg-navy-500 dark:text-navy-50 dark:hover:bg-navy-450 dark:focus:bg-navy-450 dark:active:bg-navy-450/90"
                x-ref="popperRef"
                @click="isShowPopper = !isShowPopper"
              >
                <span>Priority</span>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-4 w-4 transition-transform duration-200"
                  x-bind:class="isShowPopper && 'rotate-180'"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="2"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
              <div x-ref="popperRoot" class="popper-root" x-bind:class="isShowPopper && 'show'">
                <div class="popper-box w-72 rounded-md border border-slate-150 bg-white dark:border-navy-600 dark:bg-navy-700">
                  <label class="relative flex">
                    <input
                      type="text"
                      class="form-input peer w-full border-y border-slate-150 bg-transparent px-4 py-2 pl-9 text-xs+ placeholder:text-slate-400/70 dark:border-navy-600"
                      placeholder="Type priority..."
                    />
                    <span class="pointer-events-none absolute flex h-full w-10 items-center justify-center text-slate-400 peer-focus:text-primary dark:text-navy-300 dark:peer-focus:text-accent">
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="h-4.5 w-4.5 transition-colors duration-200"
                        fill="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path d="M3.316 13.781l.73-.171-.73.171zm0-5.457l.73.171-.73-.171zm15.473 0l.73-.171-.73.171zm0 5.457l.73.171-.73-.171zm-5.008 5.008l-.171-.73.171.73zm-5.457 0l-.171.73.171-.73zm0-15.473l-.171-.73.171.73zm5.457 0l.171-.73-.171.73zM20.47 21.53a.75.75 0 101.06-1.06l-1.06 1.06zM4.046 13.61a11.198 11.198 0 010-5.115l-1.46-.342a12.698 12.698 0 000 5.8l1.46-.343zm14.013-5.115a11.196 11.196 0 010 5.115l1.46.342a12.698 12.698 0 000-5.8l-1.46.343zm-4.45 9.564a11.196 11.196 0 01-5.114 0l-.342 1.46c1.907.448 3.892.448 5.8 0l-.343-1.46zM8.496 4.046a11.198 11.198 0 015.115 0l.342-1.46a12.698 12.698 0 00-5.8 0l.343 1.46zm0 14.013a5.97 5.97 0 01-4.45-4.45l-1.46.343a7.47 7.47 0 005.568 5.568l.342-1.46zm5.457 1.46a7.47 7.47 0 005.568-5.567l-1.46-.342a5.97 5.97 0 01-4.45 4.45l.342 1.46zM13.61 4.046a5.97 5.97 0 014.45 4.45l1.46-.343a7.47 7.47 0 00-5.568-5.567l-.342 1.46zm-5.457-1.46a7.47 7.47 0 00-5.567 5.567l1.46.342a5.97 5.97 0 014.45-4.45l-.343-1.46zm8.652 15.28l3.665 3.664 1.06-1.06-3.665-3.665-1.06 1.06z">
                        </path>
                      </svg>
                    </span>
                  </label>
                  <ul class="my-2">
                    <li>
                      <a
                        href="#"
                        class="flex items-center space-x-2.5 px-3 py-1 tracking-wide outline-none transition-all hover:bg-slate-100 focus:bg-slate-100 dark:hover:bg-navy-600 dark:focus:bg-navy-600"
                      >
                        <div class="avatar h-5 w-5">
                          <div class="is-initial rounded-full border border-error/30 bg-error/10 uppercase text-error">
                            H
                          </div>
                        </div>
                        <div>
                          <p class="text-slate-700 line-clamp-1 dark:text-navy-100">
                            High
                          </p>
                        </div>
                      </a>
                    </li>
                    <li>
                      <a
                        href="#"
                        class="flex items-center space-x-2.5 px-3 py-1 tracking-wide outline-none transition-all hover:bg-slate-100 focus:bg-slate-100 dark:hover:bg-navy-600 dark:focus:bg-navy-600"
                      >
                        <div class="avatar h-5 w-5">
                          <div class="is-initial rounded-full border border-warning/30 bg-warning/10 uppercase text-warning">
                            M
                          </div>
                        </div>

                        <div>
                          <p class="text-slate-700 line-clamp-1 dark:text-navy-100">
                            Medium
                          </p>
                        </div>
                      </a>
                    </li>
                    <li>
                      <a
                        href="#"
                        class="flex items-center space-x-2.5 px-3 py-1 tracking-wide outline-none transition-all hover:bg-slate-100 focus:bg-slate-100 dark:hover:bg-navy-600 dark:focus:bg-navy-600"
                      >
                        <div class="avatar h-5 w-5">
                          <div class="is-initial rounded-full border border-success/30 bg-success/10 uppercase text-success">
                            L
                          </div>
                        </div>
                        <div>
                          <p class="text-slate-700 line-clamp-1 dark:text-navy-100">
                            Low
                          </p>
                        </div>
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>

            <button
              x-tooltip="'Sort'"
              class="btn h-9 w-9 p-0 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5 w-5"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="1.5"
                  d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4"
                >
                </path>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
