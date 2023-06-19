defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.CommentsComponent do
  use LiveSupWeb, :component
  use Timex
  use Phoenix.HTML

  alias LiveSup.Schemas.User
  use Phoenix.HTML

  attr(:comments, :list, required: true)
  attr(:target, :any, required: true)
  attr(:current_user, :any, required: true)
  attr(:task, :list, required: true)

  def render(assigns) do
    ~H"""
    <div class="flex items-center space-x-4 pl-4 w-full sm:h-14 border-b border-slate-100 dark:border-navy-400">
      <div class="h-14 sm:h-8">
        <p class="text-tiny uppercase text-slate-400 dark:text-navy-300">
          Created By
        </p>
        <p class="mt-1 text-xs font-medium text-slate-700 dark:text-navy-100">
          <%= @task.created_by.first_name %> <%= @task.created_by.last_name %>
        </p>
      </div>
      <div class="mx-4 my-1 h-14 sm:h-8 w-px bg-slate-200 dark:bg-navy-500"></div>
      <div class="h-14 sm:h-8">
        <p class="text-tiny uppercase text-slate-400 dark:text-navy-300">
          Created On
        </p>
        <p class="mt-1 text-xs font-medium text-slate-700 dark:text-navy-100">
          <%= Timex.format!(@task.inserted_at, "%m-%d-%y %H:%M", :strftime) %>
        </p>
      </div>
      <div class="mx-4 my-1 h-14 sm:h-8 w-px bg-slate-200 dark:bg-navy-500"></div>
      <div class="h-14 sm:h-8">
        <p class="text-tiny uppercase text-slate-400 dark:text-navy-300">
          Due On
        </p>
        <p class="mt-1 text-xs font-medium text-slate-700 dark:text-navy-100">
          <%= (@task.due_on && Timex.format!(@task.due_on, "%m-%d-%y %H:%M", :strftime)) || "N/A" %>
        </p>
      </div>
    </div>
    <div class="mt-0 flex w-full flex-col lg:mr-80">
      <%= if Enum.count(@comments) > 0 do %>
        <div
          id="comments"
          phx-update="stream"
          class="grow overflow-y-auto overflow-x-hidden px-2 pt-4 transition-all duration-[.25s] scrollbar-sm min-h-[100px] sm:h-[calc(100vh-239px)]"
        >
          <div
            :for={{dom_id, comment} <- @comments}
            id={dom_id}
            class={"flex #{if(!is_nil(comment.created_by) && @current_user.id == comment.created_by.id, do: "justify-end", else: "")} space-x-2 sm:space-x-3 mb-3"}
          >
            <div class={"avatar  #{if(!is_nil(comment.created_by) && @current_user.id == comment.created_by.id, do: "order-last ml-2 sm:ml-3", else: "")}"}>
              <img
                class="rounded-full"
                src={User.default_avatar_url(comment.created_by)}
                alt="avatar"
              />
            </div>
            <div class="flex flex-col items-start space-y-3.5">
              <div class="flex relative rounded-2xl rounded-tl-none bg-info/10 p-3 text-slate-700 shadow-sm dark:bg-navy-600 dark:text-slate-300">
                <div class="grow pb-2">
                  <.markdown_field value={comment.body} class="text-xs dark:text-slate-300" />
                </div>
                <p class="mt-1 mb-1 mr-3 bottom-0 right-0 absolute flex-1 text-right text-tiny text-slate-400 dark:text-navy-300 h-">
                  <%= Timex.format!(comment.inserted_at, "%H:%M", :strftime) %>
                </p>
              </div>
            </div>
          </div>
        </div>
      <% else %>
        <p class="m-4 min-h-[100px] sm:h-[calc(100vh-233px)]">
          There are no comments yet.
        </p>
      <% end %>

      <.form for={%{}} as={:comment} phx-submit="add_comment" phx-target={@target}>
        <div class="before:block  before:w-full before:absolute before:h-3 before:-top-3 before:from-slate-100 before:to-transparent before:bg-gradient-to-t dark:before:from-navy-500 chat-footer relative flex h-12 w-full shrink-0 items-center justify-between border-t border-slate-150 bg-white py-2 transition-[padding,width] duration-[.25s] dark:border-navy-600 dark:bg-navy-800">
          <div class="-ml-1.5 flex flex-1 space-x-2 pl-4">
            <button class="btn h-9 w-9 shrink-0 rounded-full p-0 text-slate-500 hover:bg-slate-300/20 focus:bg-slate-300/20 active:bg-slate-300/25 dark:text-navy-200 dark:hover:bg-navy-300/20 dark:focus:bg-navy-300/20 dark:active:bg-navy-300/25">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-5.5 w-5.5"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="1.5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"
                >
                </path>
              </svg>
            </button>

            <input
              name="body"
              type="text"
              class="form-input h-9 w-full bg-transparent placeholder:text-slate-400/70"
              placeholder="Write the comment"
            />

            <div class="-mr-1.5 flex">
              <button class="btn h-9 w-9 shrink-0 rounded-full p-0 text-primary hover:bg-primary/20 focus:bg-primary/20 active:bg-primary/25 dark:text-accent-light dark:hover:bg-accent-light/20 dark:focus:bg-accent-light/20 dark:active:bg-accent-light/25">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="h-5.5 w-5.5"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  stroke-width="1.5"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="m9.813 5.146 9.027 3.99c4.05 1.79 4.05 4.718 0 6.508l-9.027 3.99c-6.074 2.686-8.553.485-5.515-4.876l.917-1.613c.232-.41.232-1.09 0-1.5l-.917-1.623C1.26 4.66 3.749 2.46 9.813 5.146ZM6.094 12.389h7.341"
                  >
                  </path>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end
