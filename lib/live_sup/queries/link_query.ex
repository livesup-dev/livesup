defmodule LiveSup.Queries.LinkQuery do
  import Ecto.Query

  alias LiveSup.Repo
  alias LiveSup.Schemas.{Link, User}

  def create!(data) do
    %Link{}
    |> Link.changeset(data)
    |> Repo.insert!()
  end

  def create(data) do
    %Link{}
    |> Link.changeset(data)
    |> Repo.insert()
  end

  def upsert(data) do
    %Link{}
    |> Link.changeset(data)
    |> Repo.insert(on_conflict: :nothing)
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def get_by_datasource!(%User{id: user_id}, slug) do
    user_id
    |> get_by_datasource_query(slug)
    |> Repo.one!()
  end

  def get_by_datasource(%User{id: user_id}, slug) do
    user_id
    |> get_by_datasource_query(slug)
    |> Repo.one()
  end

  def update(%Link{} = model, attrs) do
    model
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def update!(%Link{} = model, attrs) do
    model
    |> Link.changeset(attrs)
    |> Repo.update!()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  defp get_by_datasource_query(user_id, slug) do
    base()
    |> where(
      [link: link, datasource: datasource],
      link.user_id == ^user_id and datasource.slug == ^slug
    )
  end

  defp base do
    from(link in Link, as: :link, join: datasource in assoc(link, :datasource), as: :datasource)
    |> preload(:datasource)
  end
end
