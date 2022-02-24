defmodule LiveSup.Tests.Queries.MetricQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Schemas.Metric
  alias LiveSup.Queries.MetricQuery
  alias LiveSup.Repo

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

      assert metric = %{
               name: "Metric One",
               slug: "metric-one",
               target: 1.0,
               unit: "%",
               settings: %{},
               labels: ["metrics"]
             }
    end
  end

  defp setup_metrics(attrs \\ %{}) do
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
    |> Enum.each(fn metric -> metric |> LiveSup.Queries.MetricQuery.insert!() end)
  end
end
