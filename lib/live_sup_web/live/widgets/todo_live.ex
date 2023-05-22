defmodule LiveSupWeb.Live.Widgets.TodoLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <div class="ls-widget-body-default">
        <div
          :if={Enum.any?(widget_data.data)}
          class="divide-y divide-gray-100 dark:divide-gray-500 max-h-80 overflow-auto"
        >
          <div
            :for={task <- widget_data.data}
            class="flex py-2 first:pt-0 gap-3 flex-wrap dark:divide-blue-300"
          >
            <div class="flex-none relative pt-1">
              <i class={LiveSup.Views.TodoTaskHelper.task_icon(task.datasource_slug)} />
            </div>
            <div class="grow">
              <p>
                <a
                  class="dark:text-primary hover:underline break-all basis-9/12"
                  target="_blank"
                  href={~p"/tasks/#{task.id}/edit"}
                  x-tooltip.light={"'#{task.title}'"}
                >
                  <%= Palette.Utils.StringHelper.truncate(task.title, max_length: 35) %>
                </a>

                <div :for={tag <- task.tags} class="badge space-x-2.5 px-1 text-info">
                  <div class="h-2 w-2 rounded-full bg-current"></div>
                  <span><%= tag %></span>
                </div>
              </p>
            </div>
          </div>
        </div>

        <p :if={length(widget_data.data) == 0} class="text-center m-2">No tasks</p>
      </div>
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
