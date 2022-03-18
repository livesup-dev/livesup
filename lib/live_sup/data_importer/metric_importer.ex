defmodule LiveSup.DataImporter.MetricImporter do
  alias LiveSup.Core.Metrics

  def import(%{"metrics" => metrics}) do
    metrics
    |> Enum.each(fn metric_attrs ->
      metric_attrs
      |> get_or_create_metric()
      |> create_values(metric_attrs)
    end)
  end

  # def import(_data), do: :ok

  defp get_or_create_metric(attrs) do
    {:ok, metric} = Metrics.upsert(attrs)
    metric
  end

  defp create_values(metric, %{"values" => values}) do
    values
    |> Enum.each(fn value_attrs ->
      metric
      |> create_value(value_attrs)
    end)
  end

  defp create_value(metric, value) do
    Metrics.upsert_value(metric, value)
  end
end
