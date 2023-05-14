defmodule LiveSupWeb.Live.Widgets.Jira.CurrentSprintLive do
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
      <!-- Jira Current Sprint -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2 text-left min-h-[132px]">
        <span class="text-center text-lg"><%= widget_data.data.name %></span>
        <p :if={widget_data.data.goal} class="text-sm text-stone-400">
          <%= Palette.Utils.StringHelper.truncate(widget_data.data.goal, max_length: 100) %>
        </p>
        <p class="text-center text-2xl font-semibold mt-3 mb-3 text-gray-500 dark:text-primary-light">
          <%= sprint_days(widget_data.data.days_left) %>
        </p>
      </div>
      <!-- /Widget Content -->
      <!-- /Jira Current Sprint -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end

  def sprint_days(days) when days == 0, do: "Last day of the sprint"
  def sprint_days(days), do: "#{days} days remaining"
end
