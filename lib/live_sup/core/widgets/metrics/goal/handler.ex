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
    current_value = metric |> MetricValueQuery.last()

    {:ok,
     %{
       name: metric.name,
       target: metric.target,
       current_value: current_value.value
     }}
  end
end
