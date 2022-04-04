defmodule LiveSup.Queries.MetricQuery do
  import Ecto.Query
  alias LiveSup.Repo
  alias LiveSup.Schemas.Metric

  def create!(data) do
    %Metric{}
    |> Metric.changeset(data)
    |> Repo.insert!()
  end

  def upsert(data) do
    %Metric{}
    |> Metric.changeset(data)
    |> Repo.insert(on_conflict: :nothing)
  end

  def create(data) do
    %Metric{}
    |> Metric.changeset(data)
    |> Repo.insert()
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

  def all() do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def delete(project) do
    project
    |> Repo.delete()
  end

  def delete_all() do
    base()
    |> Repo.delete_all()
  end

  def base, do: from(Metric, as: :metric)
end
