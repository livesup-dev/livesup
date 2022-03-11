defmodule LiveSup.Tests.Queries.MetricValueQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Helpers.DateHelper
  alias LiveSup.Queries.MetricValueQuery

  setup [:setup_metrics]

  describe "Getting metric values" do
    @describetag :metric_query_value

    test "return metric values" do
      metrics = MetricValueQuery.all()
      assert length(metrics) == 6
    end

    test "return by metric" do
      metric_values =
        "metric-one"
        |> MetricValueQuery.by_metric()

      assert length(metric_values) == 3
    end

    test "sum by metric" do
      value =
        "metric-one"
        |> MetricValueQuery.sum()

      assert value == 15
    end
  end

  defp setup_metrics(_attrs) do
    [
      %{
        name: "Metric One",
        slug: "metric-one",
        target: 1.0,
        unit: "%",
        settings: %{},
        labels: ["metrics"]
      },
      %{
        name: "Metric Second",
        slug: "metric-second",
        target: 2.0,
        unit: "%",
        settings: %{},
        labels: ["metrics"]
      }
    ]
    |> Enum.each(fn metric ->
      metric
      |> LiveSup.Queries.MetricQuery.insert!()
      |> setup_metric_values()
    end)
  end

  defp setup_metric_values(%{id: metric_id}) do
    [
      %{
        value: 2,
        metric_id: metric_id,
        value_date: DateHelper.parse_date("2021-07-02 00:00:00")
      },
      %{
        value: 5,
        metric_id: metric_id,
        value_date: DateHelper.parse_date("2021-07-03 00:00:00")
      },
      %{
        value: 8,
        metric_id: metric_id,
        value_date: DateHelper.parse_date("2021-07-04 00:00:00")
      }
    ]
    |> Enum.each(fn metric ->
      metric |> LiveSup.Queries.MetricValueQuery.insert!()
    end)
  end
end
