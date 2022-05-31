defmodule LiveSup.DataImporter.MetricImporter do
  alias LiveSup.Core.Metrics
  import Logger

  def import(%{"metrics" => metrics} = data) do
    debug("MetricImporter:import")

    metrics
    |> Enum.each(fn metric_attrs ->
      metric_attrs
      |> get_or_create_metric()
      |> create_values(metric_attrs)
    end)

    data
  end

  def import(data), do: data

  # def import(_data), do: :ok

  defp get_or_create_metric(attrs) do
    {:ok, metric} = Metrics.upsert(attrs)
    metric
  end

  defp create_values(%{name: metric_name} = metric, %{"values" => values}) do
    debug("MetricImporter:#{metric_name}:create_values")

    values
    |> Enum.each(fn value_attrs ->
      metric
      |> create_value(value_attrs)
    end)
  end

  defp create_value(%{name: metric_name} = metric, value) do
    debug("MetricImporter:#{metric_name}:create_value")
    Metrics.upsert_value!(metric, value)
  end
end
