defmodule LiveSupWeb.Live.Widgets.Metrics.GoalLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias VegaLite, as: Vl

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component module={SmartRenderComponent} id={@widget_data.id}  let={widget_data} widget_data={@widget_data}>
      <!-- Incidents by Type -->
      <.live_component module={WidgetHeaderComponent} id={"#{widget_data.id}-header"} widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="p-2 grid justify-items-center">
        <%= live_component(LiveSupWeb.Output.VegaLiteStaticComponent, id: "blameless-incidents-by-type-chart", spec: build_spec(widget_data)) %>
      </div>
      <!-- /Widget Content -->
      <!-- /Incidents by Type -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
    </.live_component>
    """
  end

  def build_spec(widget_data) do
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "title" => "Customer Acquired",
      "width" => "container",
      "height" => "container",
      "data" => %{
        "values" => [
          %{"target" => widget_data[:target], "current_value" => widget_data[:current_value]}
        ]
      },
      "background" => nil,
      "mark" => %{"type" => "arc", "tooltip" => true},
      "encoding" => %{
        "theta" => %{
          "field" => "Percentage complete",
          "type" => "quantitative",
          "scale" => %{"domain" => [0, 100]}
        }
      }
    }
  end
end
