defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.LocalTaskComponent do
  use LiveSupWeb, :component
  alias Phoenix.LiveView.JS

  alias LiveSup.Schemas.User
  alias LiveSup.Views.TodoTaskHelper
  alias LiveSup.Schemas.TodoTask
  alias LiveSupWeb.Live.Todo.Components.TaskActionComponent

  attr(:task, :map, required: true)

  def render(assigns) do
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
end
