defmodule LiveSupWeb.Todo.Components.TaskRowComponent do
  use LiveSupWeb, :component
  alias Phoenix.LiveView.JS

  alias LiveSup.Schemas.User
  alias LiveSup.Views.TodoTaskHelper
  alias LiveSupWeb.Live.Todo.Components.TaskActionComponent

  attr(:task, :map, required: true)

  def render(assigns) do
    ~H"""
    <div class={border_color(@task.inserted_at)}>
      <div class="flex items-center space-x-2 sm:space-x-3 ml-2">
        <label class="flex">
          <TaskActionComponent.render task={@task} />
        </label>
        <h2
          class="cursor-pointer text-slate-600 line-clamp-1 dark:text-navy-100"
          phx-click={
            JS.push("select_task", value: %{id: @task.id})
            |> JS.toggle(to: "#edit-todo-drawer")
          }
        >
          <%= @task.title %>
        </h2>
      </div>
      <div class="mt-1 flex items-end justify-between ml-2">
        <div class="flex flex-wrap items-center font-inter text-xs">
          <p><.from_now value={@task.inserted_at} /></p>
          <div class="m-1.5 w-px self-stretch bg-slate-200 dark:bg-navy-500"></div>
          <span class="flex items-center space-x-1">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-3.5 w-3.5"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
              >
              </path>
            </svg>
            <span>06:00</span>
          </span>
          <div class="m-1.5 w-px self-stretch bg-slate-200 dark:bg-navy-500"></div>
          <div :if={@task.priority} class={TodoTaskHelper.priority_class(@task.priority)}>
            <div class="h-2 w-2 rounded-full bg-current"></div>
            <span><%= @task.priority %></span>
          </div>

          <div :for={tag <- @task.tags} class="badge space-x-2.5 px-1 text-info">
            <div class="h-2 w-2 rounded-full bg-current"></div>
            <span><%= tag %></span>
          </div>
          <div class="m-1.5 w-px self-stretch bg-slate-200 dark:bg-navy-500"></div>
        </div>
        <div class="flex items-center space-x-1">
          <div
            :if={length(@task.comments) > 0}
            class="flex h-4.5 min-w-[1.125rem] items-center justify-center rounded-full bg-primary px-1.5 text-tiny+ font-medium leading-none text-white dark:bg-accent"
          >
            <%= length(@task.comments) %>
          </div>
          <div class="avatar h-6 w-6">
            <img class="rounded-full" src={created_by_avatar(@task)} alt="avatar" />
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp created_by_avatar(%{created_by: user}) do
    User.default_avatar_url(user)
  end

  defp border_color(inserted_at) do
    number_of_days = Palette.Utils.DateHelper.diff_in_days(inserted_at)

    color =
      case number_of_days do
        n when n <= 3 -> "border-l-orange-900"
        n when n > 20 -> "border-l-orange-100"
        n when n > 10 -> "border-l-orange-300"
        n when n >= 4 -> "border-l-orange-700"
      end

    "border-l-4 #{color} border-b py-3 dark:border-navy-500 hover:bg-slate-100 dark:hover:bg-navy-600 mb-1"
  end
end
