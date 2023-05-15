defmodule LiveSupWeb.Live.Widgets.NoteLive do
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
      <!-- Note -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="items-center p-2 bg-white rounded-md dark:bg-darker markdown min-h-[132px]">
        <%= raw(widget_data.data[:html_content]) %>
      </div>
      <!-- /Widget Content -->
      <!-- /Team Members -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
