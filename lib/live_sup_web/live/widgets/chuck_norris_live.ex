defmodule LiveSupWeb.Live.Widgets.ChuckNorrisLive do
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
      <!-- Chuck Norris -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="flex-auto min-h-[132px]">
        <p class="p-2"><%= widget_data.data %></p>
      </div>
      <!-- /Widget Content -->
      <!-- /Chuck Norris -->
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end
end
