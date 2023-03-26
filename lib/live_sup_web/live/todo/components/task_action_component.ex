defmodule LiveSupWeb.Live.Todo.Components.TaskActionComponent do
  use LiveSupWeb, :component

  attr(:task, :map, required: true)

  def render(assigns) do
    assigns
    |> do_render()
  end

  defp do_render(%{task: %{datasource_slug: "github-datasource"}} = assigns) do
    ~H"""
    <i class="fa-brands fa-github text-2xl"></i>
    """
  end

  defp do_render(%{task: %{datasource_slug: nil}} = assigns) do
    ~H"""
    <input
      phx-click="toggle"
      phx-value-id={@task.id}
      class="form-radio is-basic h-5 w-5 rounded-full border-slate-400/70 checked:border-primary checked:bg-primary hover:border-primary focus:border-primary dark:border-navy-400 dark:checked:border-accent dark:checked:bg-accent dark:hover:border-accent dark:focus:border-accent"
      name="basic"
      type="radio"
      checked={@task.completed}
    />
    """
  end
end
