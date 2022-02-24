defmodule LiveSup.Seeds.MetricsSeeds do
  alias LiveSup.Helpers.DateHelper
  alias LiveSup.Core.Metrics

  def seed do
    Metrics.by_slug("test")
    |> insert_data()
  end

  defp insert_data(nil) do
    %{
      name: "Awesome Goal",
      slug: "test",
      target: 100,
      unit: "MM",
      settings: %{},
      labels: ["metrics"]
    }
    |> Metrics.insert!()
    |> insert_metric_values()
  end

  defp insert_data(_metric), do: true

  defp insert_metric_values(metric) do
    [
      %{
        value: 10,
        value_date: DateHelper.parse_date("2021-07-02 00:00:00")
      },
      %{
        value: 50,
        value_date: DateHelper.parse_date("2021-07-09 00:00:00")
      },
      %{
        value: 5,
        value_date: DateHelper.parse_date("2021-07-16 00:00:00")
      }
    ]
    |> Enum.map(fn value ->
      metric
      |> LiveSup.Core.Metrics.insert_value!(value)
    end)
  end
end
