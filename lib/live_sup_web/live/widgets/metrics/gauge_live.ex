defmodule LiveSupWeb.Live.Widgets.Metrics.GaugeLive do
  use LiveSupWeb.Live.Widgets.WidgetLive

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id}  let={widget_data} widget_data={@widget_data}>
      <!-- Metrics Goal -->
      <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="p-2 grid justify-items-center">
        <%= live_component(LiveSupWeb.Output.PlotlyStaticComponent, id: "#{widget_data.id}-gauge", spec: build_spec(widget_data)) %>
      </div>
      <!-- /Widget Content -->
      <!-- /Metrics Goal -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
    </.live_component>
    """
  end

  def build_spec(widget_data) do
    %{
      domain: %{x: [0, 1], y: [0, 1]},
      value: widget_data.data[:current_value],
      type: "indicator",
      mode: "gauge+number+delta",
      delta: %{reference: widget_data.data[:target]},
      gauge: %{
        axis: %{range: [nil, widget_data.data[:target]]}
      }
    }
  end
end
