defmodule LiveSupWeb.Live.Widgets.Metrics.MetricsHelper do
  def build_gauge(
        %{
          data: %{target: target, current_value: current_value, unit: unit},
          public_settings: public_settings
        } = widget_data
      ) do
    limit = target |> trunc()

    step =
      (target / 3)
      |> round()

    range_color_order = Map.get(public_settings, "range_color_order", "asc")
    colors = colors(range_color_order)

    ranges = Enum.to_list(0..limit//step)

    gauge_ranges =
      ranges
      |> Enum.with_index()
      |> delete_if_invalid_range()
      |> Enum.map(fn {value, index} ->
        next =
          if index + 1 < length(ranges) do
            ranges |> Enum.at(index + 1)
          else
            target
          end

        %{
          range: [value, next],
          color: colors |> Enum.at(index)
        }
      end)

    # TODO: Delta need to be improved. It should be a setting
    %{
      domain: %{x: [0, 1], y: [0, 1]},
      value: current_value,
      type: "indicator",
      mode: "gauge+number+delta",
      delta: %{reference: current_value - (target - current_value)},
      number: %{suffix: unit},
      gauge: %{
        bar: %{color: "#173557"},
        axis: %{range: [nil, target]},
        steps: gauge_ranges
      }
    }
  end

  defp delete_if_invalid_range(ranges) when length(ranges) > 3 do
    ranges |> List.delete_at(length(ranges) - 1)
  end

  defp delete_if_invalid_range(ranges), do: ranges

  defp colors("asc"), do: ["#12B431", "#DDD72C", "#EC8116"]
  defp colors("desc"), do: ["#EC8116", "#DDD72C", "#12B431"]
end
