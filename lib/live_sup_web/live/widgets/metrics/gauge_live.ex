defmodule LiveSupWeb.Live.Widgets.Metrics.GaugeLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias LiveSupWeb.Live.Widgets.Metrics.MetricsHelper

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
      <div class="p-2 grid justify-items-center  min-h-[200px]">
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
    widget_data |> MetricsHelper.build_gauge()
  end
end
