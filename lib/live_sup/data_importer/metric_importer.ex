defmodule LiveSup.DataImporter.MetricImporter do
  alias LiveSup.Core.Metrics

  def import(%{"metrics" => metrics}) do
    metrics
    |> Enum.each(fn metric_attrs ->
      metric_attrs
      |> get_or_create_metric()
    end)
  end

  def import(_data), do: :ok

  defp get_or_create_metric(%{"id" => id} = attrs) do
    Metrics.get(id) || Metrics.create(attrs)
  end
end
