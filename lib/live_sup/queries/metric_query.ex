defmodule LiveSup.Queries.MetricQuery do
  import Ecto.Query
  alias LiveSup.Repo
  alias LiveSup.Schemas.Metric

  def insert!(data) do
    %Metric{}
    |> Metric.create_changeset(data)
    |> Repo.insert!()
  end

  def update(%Metric{} = model, attrs) do
    model
    |> Metric.changeset(attrs)
    |> Repo.update()
  end

  def update!(%Metric{} = model, attrs) do
    model
    |> Metric.changeset(attrs)
    |> Repo.update!()
  end

  def insert_or_update(%Metric{} = model, attrs) do
    model
    |> Metric.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def by_slug(slug) do
    query =
      from(
        t in Metric,
        where: t.slug == ^slug
      )

    query
    |> Repo.one()
  end

  def get_all() do
    Repo.all(Metric)
  end
end
