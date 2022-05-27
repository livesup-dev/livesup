defmodule LiveSup.Queries.MetricValueQuery do
  import Ecto.Query
  alias LiveSup.Repo
  alias LiveSup.Schemas.{MetricValue, Metric}
  import Logger

  def get!(id) do
    base() |> Repo.get!(id)
  end

  def delete_all() do
    base() |> Repo.delete_all()
  end

  def all() do
    Repo.all(MetricValue)
  end

  def insert!(data) do
    %MetricValue{}
    |> MetricValue.create_changeset(data)
    |> Repo.insert!()
  end

  def upsert!(data) do
    debug("MetricValueQuery:upsert")

    %MetricValue{}
    |> MetricValue.create_changeset(data)
    |> Repo.insert!(on_conflict: :nothing)
  end

  def by_metric(%Metric{id: id}) do
    from(
      v in MetricValue,
      join: m in assoc(v, :metric),
      where: m.id == ^id
    )
    |> Repo.all()
  end

  def by_metric(metric_slug) when is_binary(metric_slug) do
    from(
      v in MetricValue,
      join: m in assoc(v, :metric),
      where: m.slug == ^metric_slug
    )
    |> Repo.all()
  end

  def sum(%Metric{id: id}) do
    from(
      v in MetricValue,
      where: v.metric_id == ^id,
      select: sum(v.value)
    )
    |> Repo.one()
  end

  def sum(metric_slug) when is_binary(metric_slug) do
    from(
      v in MetricValue,
      join: m in assoc(v, :metric),
      where: m.slug == ^metric_slug,
      select: sum(v.value)
    )
    |> Repo.one()
  end

  def last(%Metric{id: id}) do
    from(
      v in MetricValue,
      where: v.metric_id == ^id,
      order_by: [desc: :value_date],
      limit: 1
    )
    |> Repo.one()
  end

  def base, do: from(MetricValue, as: :metric_value_query)
end
