defmodule LiveSupWeb.Live.Widgets.Jira.CurrentSprintStatsLive do
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
          id: "jira-current-sprint-#{@widget_data.id}",
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
    # Initialize the specification, optionally with some top-level properties
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "description" => "",
      "data" => %{
        "values" => widget_data.data
      },
      "background" => nil,
      "mark" => "arc",
      "encoding" => %{
        "theta" => %{"field" => "count", "type" => "quantitative", "stack" => true},
        "color" => %{
          "field" => "status",
          "type" => "nominal",
          "legend" => %{"title" => "Type", "labelColor" => "white", "titleColor" => "white"}
        },
        "radius" => %{
          "field" => "count",
          "scale" => %{"type" => "sqrt", "zero" => true, "rangeMin" => 20}
        }
      },
      "layer" => [
        %{
          "mark" => %{"type" => "arc", "innerRadius" => 20, "stroke" => "#fff"}
        },
        %{
          "mark" => %{"type" => "text", "radiusOffset" => 10},
          "encoding" => %{
            "text" => %{"field" => "count", "type" => "quantitative"}
          }
        }
      ]
    }
  end
end
