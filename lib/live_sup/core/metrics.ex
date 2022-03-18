defmodule LiveSup.Core.Metrics do
  use Task
  alias LiveSup.Queries.{MetricQuery, MetricValueQuery}
  alias LiveSup.Schemas.Metric

  defdelegate all(), to: MetricQuery
  defdelegate create(data), to: MetricQuery
  defdelegate create!(data), to: MetricQuery
  defdelegate get!(id), to: MetricQuery
  defdelegate get(id), to: MetricQuery
  defdelegate delete(id), to: MetricQuery
  defdelegate update(metric, attrs), to: MetricQuery
  defdelegate upsert(attrs), to: MetricQuery

  def by_slug(slug) do
    slug |> MetricQuery.by_slug()
  end

  def insert_value!(%Metric{id: metric_id}, metric_value) do
    MetricValueQuery.insert!(Map.merge(metric_value, %{metric_id: metric_id}))
  end

  def upsert_value(%Metric{id: metric_id}, metric_value) do
    MetricValueQuery.upsert(Map.merge(metric_value, %{"metric_id" => metric_id}))
  end
end
