defmodule LiveSup.Core.Widgets.Metrics.Goal.Handler do
  alias LiveSup.Core.Metrics
  alias LiveSup.Queries.MetricValueQuery

  def get_data(%{"metric" => metric_slug}) do
    metric =
      metric_slug
      |> Metrics.by_slug()

    current_value = metric |> MetricValueQuery.sum()

    {:ok,
     %{
       name: metric.name,
       target: metric.target,
       current_value: current_value
     }}
  end
end
