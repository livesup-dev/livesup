defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.LocalTaskComponent do
  use LiveSupWeb, :component

  alias LiveSup.Schemas.TodoTask
  alias LiveSup.Schemas.User

  attr(:task, :map, required: true)
  attr(:editing_task, :boolean, default: false)
  attr(:target, :any, required: true)

  def render(%{editing_task: false} = assigns) do
    ~H"""
    <div class="flex flex-col">
      <div class="flex items-center w-full h-16 sm:h-14 border-b border-slate-100 dark:border-navy-400">
        <button
          :if={!@task.completed}
          type="button"
          phx-target={@target}
          phx-click="complete"
          class="btn sm:h-8 text-left text-xs px-2 mr-8 space-x-2 border border-slate-300 font-medium text-slate-300 hover:border-green-300 hover:text-green-300 focus:border-green-300 focus:text-green-300"
        >
          <i class="fa-regular fa-check-square"></i>
          <span>Mark as Complete</span>
        </button>
        <div :if={@task.assigned_to} class="avatar h-8 w-8">
          <div class="is-initial rounded-full bg-primary/10 text-base uppercase text-primary dark:bg-accent-light/10 dark:text-accent-light">
            <img
              class="rounded-full"
              src={User.default_avatar_url(@task.assigned_to)}
              x-tooltip={"'#{@task.assigned_to.first_name} #{@task.assigned_to.last_name}'"}
            />
          </div>
        </div>
        <div
          :if={@task.assigned_to && @task.priority}
          class="mx-4 my-1 h-6 w-px bg-slate-200 dark:bg-navy-500"
        >
        </div>
        <span :if={@task.priority} class="badge bg-info text-white">
          <%= @task.priority %>
        </span>
      </div>
      <div class="relative after:block after:w-full after:absolute after:h-3 after:-bottom-3 after:from-slate-100 after:to-transparent after:bg-gradient-to-t dark:after:from-navy-500">
        <div class="mt-4 mr-4 pb-2 relative after:block after:w-full after:absolute after:h-3 after:-bottom-3 after:from-white after:to-transparent after:bg-gradient-to-b dark:after:from-navy-500">
          <div :if={@task.tags} class="flex space-x-2 mb-3">
            <span
              :for={{tag} <- @task.tags}
              class="border border-primary text-primary text-tiny font-medium inline-flex items-center px-1.5 py-0.5 rounded mr-1 dark:bg-navy-600 dark:text-slate-100 dark:border-slate-500"
            >
              <i class="fa-solid fa-tag w-3 h-3 mr-1"></i><%= tag %>
            </span>
          </div>
          <h3 class="text-4xl font-normal text-slate-600 dark:text-slate-100">
            <%= @task.title %>
          </h3>
        </div>
        <div class="mr-4 scrollbar-sm overflow-y-auto p-2 min-h-[100px] h-[calc(100vh-326px)]">
          <.markdown_field value={@task.description} empty_value="No description provided." />
        </div>
      </div>
      <.simple_form as={:task} class="relative items-center mt-2">
        <:actions>
          <a
            href="#"
            phx-click={JS.exec("data-cancel", to: "#modal")}
            class="btn inline min-w-[7rem] rounded-full border border-slate-300 font-medium text-slate-800 hover:bg-slate-150 focus:bg-slate-150 active:bg-slate-150/80 dark:border-navy-450 dark:text-navy-50 dark:hover:bg-navy-500 dark:focus:bg-navy-500 dark:active:bg-navy-500/90"
          >
            Cancel
          </a>
          <button
            id="edit-mode"
            type="button"
            phx-target={@target}
            phx-click="edit_mode"
            phx-value-mode="true"
            class="btn inline-flex min-w-[7rem] rounded-full bg-primary font-medium text-white hover:bg-primary-focus focus:bg-primary-focus active:bg-primary-focus/90 dark:bg-accent dark:hover:bg-accent-focus dark:focus:bg-accent-focus dark:active:bg-accent/90"
          >
            <i class="fa-regular fa-pen-to-square mr-3"></i>
            <span class="inner-text">Edit</span>
          </button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def render(%{editing_task: true} = assigns) do
    ~H"""
    <.simple_form as={:task} target={@target}>
      <.hidden_input name="id" value={@task.id} />
      <.hidden_input name="todo_id" value={@task.todo_id} />
      <.text name="title" value={@task.title} label="Title" required={true} />
      <.textarea name="description" value={@task.description} label="Description" />
      <.select
        id="priority"
        name="priority"
        options={TodoTask.priorities()}
        label="Priority"
        value={@task.priority}
        prompt="Select Priority"
        class="dark:bg-navy-700"
      />
      <.alert :if={@error} description={@error} color={:error} />
      <:actions>
        <.close_modal_button />
        <.save_modal_button />
      </:actions>
    </.simple_form>
    """
  end
end
