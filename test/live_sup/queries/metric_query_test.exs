defmodule LiveSup.Tests.Queries.MetricQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.MetricQuery

  setup [:setup_metrics]

  describe "Getting metrics" do
    @describetag :metric_query

    test "return metrics" do
      metrics = MetricQuery.all()
      assert length(metrics) == 2
    end

    test "return by slug" do
      metric =
        "metric-one"
        |> MetricQuery.by_slug()

      assert %{
               name: metric.name,
               slug: metric.slug,
               target: 1.0,
               unit: metric.unit,
               settings: metric.settings,
               labels: metric.labels
             } == %{
               name: "Metric One",
               slug: "metric-one",
               target: 1.0,
               unit: "%",
               settings: %{},
               labels: ["metrics"]
             }
    end
  end

  defp setup_metrics(_) do
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
        target: 8.0,
        unit: "min",
        settings: %{},
        labels: ["metrics"]
      }
    ]
    |> Enum.each(fn metric -> metric |> LiveSup.Queries.MetricQuery.create!() end)
  end
end
