defmodule LiveSupWeb.Live.Widgets.Blameless.IncidentsBySeverityLive do
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
      <!-- Incidents by Type -->
      <.live_component
        module={WidgetHeaderComponent}
        id={"#{widget_data.id}-header"}
        widget_data={widget_data}
      />
      <!-- Widget Content -->
      <div class="p-2 grid justify-items-center  min-h-[132px]">
        <%= live_component(LiveSupWeb.Output.VegaLiteStaticComponent,
          id: "blameless-incidents-by-severity-chart",
          spec: build_spec(widget_data)
        ) %>
      </div>
      <!-- /Widget Content -->
      <!-- /Incidents by Type -->
      <.live_component
        module={WidgetFooterComponent}
        id={"#{widget_data.id}-footer"}
        widget_data={widget_data}
      />
    </.live_component>
    """
  end

  def build_spec(widget_data) do
    data =
      widget_data.data
      |> Enum.map(fn {key, value} ->
        %{"severity" => key, "value" => value}
      end)

    # Initialize the specification, optionally with some top-level properties
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "description" => "",
      "data" => %{
        "values" => data
      },
      "background" => nil,
      "mark" => "arc",
      "encoding" => %{
        "theta" => %{"field" => "value", "type" => "quantitative", "stack" => true},
        "color" => %{
          "field" => "severity",
          "type" => "nominal",
          "legend" => %{"title" => "Severity", "labelColor" => "white", "titleColor" => "white"}
        }
      },
      "layer" => [
        %{
          "mark" => %{"type" => "arc", "outerRadius" => 80}
        },
        %{
          "mark" => %{"type" => "text", "radius" => 140}
        }
      ]
    }
  end
end
