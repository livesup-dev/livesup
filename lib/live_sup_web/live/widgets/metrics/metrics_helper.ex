defmodule LiveSupWeb.Live.Widgets.Metrics.MetricsHelper do
  def build_gauge(%{data: %{target: target}} = widget_data) do
    limit = target |> trunc()

    step =
      (target / 3)
      |> round()

    colors = ["#12B431", "#DDD72C", "#EC8116"]

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

    %{
      domain: %{x: [0, 1], y: [0, 1]},
      value: widget_data.data[:current_value],
      type: "indicator",
      mode: "gauge+number+delta",
      delta: %{reference: target},
      gauge: %{
        bar: %{color: "#173557"},
        axis: %{range: [nil, target]},
        steps: gauge_ranges
      }
    }
  end

  def delete_if_invalid_range(ranges) when length(ranges) > 3 do
    ranges |> List.delete_at(length(ranges) - 1)
  end

  def delete_if_invalid_range(ranges), do: ranges
end
