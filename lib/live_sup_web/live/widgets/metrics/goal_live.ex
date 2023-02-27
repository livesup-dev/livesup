defmodule LiveSupWeb.Live.Widgets.Metrics.GoalLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  alias VegaLite, as: Vl

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
      <div class="p-2 grid justify-items-center min-h-[132px]">
        <%= live_component(LiveSupWeb.Output.VegaLiteStaticComponent,
          id: "#{widget_data.id}-chart",
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

  def build_spec(%{data: widget_data}) do
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
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
