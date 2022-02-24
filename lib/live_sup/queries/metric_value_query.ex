defmodule LiveSup.Queries.MetricValueQuery do
  import Ecto.Query
  alias LiveSup.Repo
  alias LiveSup.Schemas.{MetricValue, Metric}

  def all() do
    Repo.all(MetricValue)
  end

  def insert!(data) do
    %MetricValue{}
    |> MetricValue.create_changeset(data)
    |> Repo.insert!()
  end

  def by_metric(%Metric{id: id}) do
    from(
      v in MetricValue,
      join: m in assoc(v, :metric),
      where: m.id == ^id
    )
    |> Repo.all()
  end

  def by_metric(slug) when is_binary(slug) do
    from(
      v in MetricValue,
      join: m in assoc(v, :metric),
      where: m.slug == ^slug
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
end
