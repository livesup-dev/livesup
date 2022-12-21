defmodule LiveSupWeb.Live.Widgets.Metrics.BulletGaugeLive do
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
      <!-- Metrics Goal -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2 w-full min-h-[200px]">
        <%= live_component(LiveSupWeb.Output.PlotlyStaticComponent,
          id: "#{widget_data.id}-gauge",
          spec: build_spec(widget_data)
        ) %>
      </div>
      <!-- /Widget Content -->
      <!-- /Metrics Goal -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end

  def build_spec(widget_data) do
    %{
      type: "indicator",
      gauge: %{
        shape: "bullet",
        axis: %{range: [nil, widget_data.data[:target]]},
        bgcolor: "white",
        steps: [%{range: [0, widget_data.data[:target]], color: "#1d3c62"}],
        bar: %{color: "#d9d2e9"}
      },
      number: %{prefix: "%"},
      value: widget_data.data[:current_value],
      delta: %{reference: widget_data.data[:target], position: "top"},
      domain: %{x: [0, 1], y: [0, 1]},
      mode: "number+gauge+delta",
      width: 450,
      height: 116
    }
  end
end
