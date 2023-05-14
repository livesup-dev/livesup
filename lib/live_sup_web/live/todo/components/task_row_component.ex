defmodule LiveSupWeb.Todo.Components.TaskRowComponent do
  use LiveSupWeb, :component
  alias Phoenix.LiveView.JS

  alias LiveSup.Schemas.User
  alias LiveSup.Views.TodoTaskHelper
  alias LiveSupWeb.Live.Todo.Components.TaskActionComponent

  attr(:task, :map, required: true)
  attr(:dom_id, :string, required: true)

  def render(assigns) do
    ~H"""
    <div id={@dom_id} class={border_color(@task.inserted_at)}>
      <div class="flex items-center space-x-2 sm:space-x-3 ml-2">
        <label class="flex">
          <TaskActionComponent.render task={@task} />
        </label>
        <h2 class={row_class(@task.completed)} phx-click={JS.navigate(~p"/tasks/#{@task.id}/edit")}>
          <%= @task.title %>
        </h2>
      </div>
      <div class="flex items-end justify-between ml-2">
        <div class="flex flex-wrap items-center font-inter text-xs">
          <p><.from_now value={@task.inserted_at} /></p>
          <div class="m-1.5 w-px self-stretch bg-slate-200 dark:bg-navy-500"></div>
          <span class="flex items-center space-x-1"></span>
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
          <div class="avatar h-6 w-6" x-tooltip={"'#{User.full_name(@task.created_by)}'"}>
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

    "border-l-4 #{color} border-b py-2 dark:border-navy-500 hover:bg-slate-100 dark:hover:bg-navy-600 mb-1"
  end

  def row_class(true) do
    "cursor-pointer text-slate-600 line-clamp-1 dark:text-navy-100 line-through"
  end

  def row_class(false) do
    "cursor-pointer text-slate-600 line-clamp-1 dark:text-navy-100"
  end
end
