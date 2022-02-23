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
      where: v.metric_id == ^id
    )
    |> Repo.all()
  end
end
