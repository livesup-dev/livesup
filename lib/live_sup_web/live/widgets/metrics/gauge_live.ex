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
        <div id={"gauge-#{@widget_data.id}"} phx-hook="PlotlyHook" phx-update="ignore" data-id={@widget_data.id}>
        </div>
      </div>
      <!-- /Widget Content -->
      <!-- /Metrics Goal -->
        <.live_component module={WidgetFooterComponent} id={"#{widget_data.id}-footer"} widget_data={widget_data} />
    </.live_component>
    """
  end

  def build_spec(%{data: widget_data}) do
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "title" => %{"text" => widget_data[:name], "color" => "white"},
      "data" => %{
        "values" => [
          %{"target" => widget_data[:target], "current_value" => widget_data[:current_value]}
        ]
      },
      "background" => nil,
      "mark" => %{"type" => "arc", "tooltip" => true},
      "encoding" => %{
        "theta" => %{
          "field" => "current_value",
          "type" => "quantitative",
          "scale" => %{"domain" => [0, widget_data[:target]]}
        }
      }
    }
  end
end
