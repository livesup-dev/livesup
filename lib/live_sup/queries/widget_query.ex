defmodule LiveSup.Queries.WidgetQuery do
  alias LiveSup.Schemas.Widget
  alias LiveSup.Repo
  import Ecto.Query

  def all do
    base()
    |> join_datasource()
    |> Repo.all()
  end

  def all(%{datasource_id: datasource_id}) do
    base()
    |> join_datasource()
    |> where([w], w.datasource_id == ^datasource_id)
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> join_datasource()
    |> Repo.get!(id)
  end

  def create(attrs) do
    %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_slug!(slug) do
    slug
    |> by_slug()
    |> Repo.one!()
  end

  def get_by_slug(slug) do
    slug
    |> by_slug()
    |> Repo.one()
  end

  defp join_datasource(query) do
    query
    |> join(:inner, [w], ds in assoc(w, :datasource))
    |> preload(:datasource)
  end

  defp by_slug(slug) do
    from(
      w in Widget,
      where: w.slug == ^slug
    )
  end

  def create!(attrs) do
    %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert!()
  end

  def update(model, attrs) do
    model
    |> Widget.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def base, do: from(Widget, as: :widget)
end
