defmodule LiveSup.Core.Widgets.Metrics.Goal.Handler do
  alias LiveSup.Core.Metrics
  alias LiveSup.Queries.MetricValueQuery

  def get_data(%{"metric" => metric_slug}) do
    metric_slug
    |> Metrics.by_slug()
    |> build_metric(metric_slug)
  end

  defp build_metric(nil, metric_slug), do: {:error, "Metric not found: #{metric_slug}"}

  defp build_metric(metric, _metric_slug) do
    # TODO: This needs to be dynamic, somehing you can
    # configure in the settings
    {:ok,
     %{
       name: metric.name,
       target: metric.target,
       unit: metric.unit,
       current_value: metric |> current_value()
     }}
  end

  defp current_value(metric) do
    case metric |> MetricValueQuery.last() do
      nil -> 0
      found_value -> found_value.value
    end
  end
end
