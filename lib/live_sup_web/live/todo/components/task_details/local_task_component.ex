defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.LocalTaskComponent do
  use LiveSupWeb, :component

  alias LiveSup.Schemas.TodoTask

  attr(:task, :map, required: true)
  attr(:editing_task, :boolean, default: false)
  attr(:target, :any, required: true)

  def render(%{editing_task: false} = assigns) do
    ~H"""
    <div class="card px-4 py-4 sm:px-5 ">
      <div class="flex justify-between">
        <h3 class="text-base font-medium text-slate-600 dark:text-navy-100">
          Todo filter styles
        </h3>
        <span class=" badge bg-success text-white">open</span>
      </div>
    </div>

    <.simple_form as={:task}>
      <.field label="Title" value={@task.title} />
      <.markdown_field value={@task.description} empty_value="No description provided." />

      <:actions>
        <.close_modal_button />
        <button
          id="edit-mode"
          type="button"
          phx-target={@target}
          phx-click="edit_mode"
          phx-value-mode="true"
          class="btn min-w-[7rem] rounded-full bg-primary font-medium text-white hover:bg-primary-focus focus:bg-primary-focus active:bg-primary-focus/90 dark:bg-accent dark:hover:bg-accent-focus dark:focus:bg-accent-focus dark:active:bg-accent/90"
        >
          <i class="fa-regular fa-pen-to-square mr-3"></i>
          <span class="inner-text">Edit</span>
        </button>
      </:actions>
    </.simple_form>
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
