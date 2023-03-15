defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.LocalTaskComponent do
  use LiveSupWeb, :component

  alias LiveSup.Schemas.TodoTask
  alias LiveSup.Core.Tasks
  alias LiveSupWeb.Live.Todo.Components.TaskDetails.CommentsComponent

  attr(:task, :map, required: true)
  attr(:editing_task, :boolean, default: false)

  def render(%{editing_task: false, task: task} = assigns) do
    assigns =
      assigns
      |> assign(:comments, fetch_comments(task))

    ~H"""
    <.xform as={:task}>
      <.markdown_field value={@task.description} empty_value="No description provided." />

      <:actions>
        <.close_modal_button />
        <button
          id="edit-mode"
          type="button"
          phx-click="edit_mode"
          phx-value-mode="true"
          class="btn min-w-[7rem] rounded-full bg-primary font-medium text-white hover:bg-primary-focus focus:bg-primary-focus active:bg-primary-focus/90 dark:bg-accent dark:hover:bg-accent-focus dark:focus:bg-accent-focus dark:active:bg-accent/90"
        >
          <i class="fa-regular fa-pen-to-square mr-3"></i>
          <span class="inner-text">Edit</span>
        </button>
      </:actions>
    </.xform>
    <CommentsComponent.render comments={@comments} />
    """
  end

  def render(%{editing_task: true} = assigns) do
    ~H"""
    <.xform as={:task}>
      <.hidden_input name="id" value={@task.id} />
      <.hidden_input name="todo_id" value={@task.todo_id} />
      <.text name="title" value={@task.title} label="title" required={true} />
      <.textarea name="description" value={@task.description} label="Description" required={true} />
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
    </.xform>
    """
  end

  defp fetch_comments(%{id: nil}), do: []

  defp fetch_comments(%{id: _id} = task) do
    task
    |> Tasks.get_comments()
  end
end
