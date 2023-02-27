defmodule LiveSupWeb.Live.Widgets.Blameless.IncidentsByDateLive do
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
          id: "blameless-incidents-by-date-chart",
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
    %{
      "$schema" => "https://vega.github.io/schema/vega-lite/v5.json",
      "description" => "",
      "data" => %{
        "values" => widget_data.data
      },
      "background" => nil,
      "mark" => "bar",
      "config" => %{
        "axis" => %{
          "grid" => false
        }
      },
      "width" => %{"step" => 40},
      "encoding" => %{
        "y" => %{
          "aggregate" => "sum",
          "field" => "value",
          "title" => "Incidents",
          "axis" => %{"labelColor" => "white", "titleColor" => "white"}
        },
        "x" => %{
          "field" => "created_at",
          "timeUnit" => "day",
          "axis" => %{"labelColor" => "white", "titleColor" => "white", "title" => "Day"}
        },
        "color" => %{
          "field" => "type",
          "legend" => %{"labelColor" => "white", "titleColor" => "white", "title" => "Type"}
        }
      }
    }
  end
end
