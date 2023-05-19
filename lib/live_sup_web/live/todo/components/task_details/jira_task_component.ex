defmodule LiveSupWeb.Live.Todo.Components.TaskDetails.JiraTaskComponent do
  use LiveSupWeb, :component

  def render(assigns) do
    ~H"""
    <.card>
      <div class="flex justify-between">
        <h3 class="text-base font-medium text-slate-600 dark:text-navy-100">
          <%= @task.title %>
        </h3>
        <.badge description={@task.external_metadata["status"]} color={:success} />
      </div>

      <div class="rounded-md rounded-t-none text-gray-700 divide-y divide-gray-400">
        <div class="prose max-w-none px-4">
          <section class="mt-4 space-y-2">
            <%= @task.description %>
          </section>
        </div>
      </div>
      <div class="flex justify-end space-x-2 mt-2">
        <a
          href={@task.external_metadata["url"]}
          target="_blank"
          class="btn space-x-2 bg-slate-150 font-medium text-slate-800 hover:bg-slate-200 focus:bg-slate-200 active:bg-slate-200/80 dark:bg-navy-500 dark:text-navy-50 dark:hover:bg-navy-450 dark:focus:bg-navy-450 dark:active:bg-navy-450/90"
        >
          <span>Open Jira</span>
          <i class="fa-solid fa-arrow-up-right-from-square text-lg"></i>
        </a>
      </div>
    </.card>
    """
  end

  defp body_to_html(nil), do: "No description provided."
  defp body_to_html(body) when is_binary(body) and body == "", do: "No description provided."

  defp body_to_html(body) when is_binary(body) do
    Palette.Utils.StringHelper.markdown_to_html(body)
  end
end
