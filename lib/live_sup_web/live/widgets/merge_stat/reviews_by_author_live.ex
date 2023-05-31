defmodule LiveSupWeb.Live.Widgets.MergeStat.ReviewsByAuthorsLive do
  use LiveSupWeb.Live.Widgets.WidgetLive
  import LiveSupWeb.Components.IconsComponent

  @impl true
  def render_widget(assigns) do
    ~H"""
    <.live_component
      :let={widget_data}
      module={SmartRenderComponent}
      id={@widget_data.id}
      widget_data={@widget_data}
    >
      <!-- Reviews by author -->
      <WidgetHeaderComponent.render widget_data={widget_data} />
      <!-- Widget Content -->
      <div class="ls-widget-body-default">
        <div :if={Enum.any?(widget_data.data)}>
          <%= live_component(Palette.Components.Live.Chart,
            id: "reviews-by-author-#{@widget_data.id}",
            spec: build_spec(widget_data)
          ) %>
        </div>
        <.empty_data_icon
          :if={Enum.empty?(widget_data.data)}
          svg_class="h-20 w-20"
          description="No stats."
        />
      </div>
      <WidgetFooterComponent.render widget_data={widget_data} />
    </.live_component>
    """
  end

  def build_spec(widget_data) do
    series =
      Enum.map(widget_data.data, fn review ->
        review["total_pull_requests_reviewed"] |> String.to_integer()
      end)

    %{
      series: [
        %{
          data: series
        }
      ],
      chart: %{
        type: "bar",
        height: 350,
        toolbar: %{
          show: false
        }
      },
      plotOptions: %{
        bar: %{
          borderRadius: 4,
          horizontal: true
        }
      },
      stroke: %{
        colors: ["#fff"]
      },
      fill: %{
        opacity: 0.8
      },
      dataLabels: %{
        enabled: false
      },
      xaxis: %{
        categories:
          Enum.map(widget_data.data, fn status ->
            status["author_login"]
          end)
      }
    }
  end
end
