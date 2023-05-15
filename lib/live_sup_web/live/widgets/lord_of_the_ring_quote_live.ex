defmodule LiveSupWeb.Live.Widgets.LordOfTheRingQuoteLive do
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
      <!-- Lord of the ring quote -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="flex-auto p-2 min-h-[132px]">
        <p><%= widget_data.data.quote %></p>
      </div>
      <!-- /Widget Content -->
      <!-- /Lord of the ring quote -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
