defmodule LiveSup.Core.Metrics do
  use Task
  alias LiveSup.Queries.{MetricQuery, MetricValueQuery}
  alias LiveSup.Schemas.Metric

  defdelegate insert!(attrs), to: MetricQuery

  def by_slug(slug) do
    slug |> MetricQuery.by_slug()
  end

  def insert_value!(%Metric{id: metric_id}, value) do
    MetricValueQuery.insert!(Map.merge(value, %{metric_id: metric_id}))
  end
end
