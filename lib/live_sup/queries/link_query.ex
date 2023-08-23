defmodule LiveSup.Queries.LinkQuery do
  import Ecto.Query

  alias LiveSup.Repo
  alias LiveSup.Schemas.{Link, User, Datasource, DatasourceInstance}

  def count do
    base()
    |> Repo.aggregate(:count)
  end

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

  def get_by_user(%User{id: user_id}), do: user_id |> get_by_user()

  def get_by_user(user_id) do
    base()
    |> where([link: link], link.user_id == ^user_id)
    |> Repo.all()
  end

  def get_by_datasource(%User{id: user_id}, slug) do
    user_id
    |> get_by_datasource_query(slug)
    |> Repo.all()
  end

  def get_by_datasource_instance(%User{} = user, %DatasourceInstance{
        id: datasource_instance_id
      }) do
    user
    |> get_by_datasource_instance(datasource_instance_id)
  end

  def get_by_datasource_instance(%User{id: user_id}, datasource_instance_id) do
    base()
    |> where(
      [link: link, datasource_instance: datasource_instance],
      link.user_id == ^user_id and datasource_instance.id == ^datasource_instance_id
    )
    |> Repo.one()
  end

  def get_by_setting(key, value) do
    base()
    |> where(
      [link: link],
      link.settings[^key] == ^value
    )
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

  def delete_by_user(user) do
    query =
      from(
        l in Link,
        where: l.user_id == ^user.id
      )

    query
    |> Repo.delete_all()
  end

  def delete_all() do
    from(l in Link)
    |> Repo.delete_all()
  end

  defp get_by_datasource_query(user_id, slug) do
    base()
    |> join(:inner, [datasource_instance: datasource_instance], datasource in Datasource,
      as: :datasource,
      on: datasource.id == datasource_instance.datasource_id
    )
    |> where(
      [link: link, datasource: datasource],
      link.user_id == ^user_id and datasource.slug == ^slug
    )
  end

  def get_all_by_user(%User{id: id}) do
    base()
    |> join(:inner, [link: link], user in User, as: :user, on: link.user_id == user.id)
    |> where([user: user], user.id == ^id)
    |> Repo.all()
  end

  def get_all_by_datasource(%User{id: user_id}, datasource_slug) do
    base()
    |> join(:inner, [datasource_instance: datasource_instance], datasource in Datasource,
      as: :datasource,
      on: datasource.id == datasource_instance.datasource_id
    )
    |> where(
      [link: link, datasource: datasource],
      link.user_id == ^user_id and datasource.slug == ^datasource_slug
    )
    |> Repo.all()
  end

  defp base do
    from(link in Link,
      as: :link,
      join: datasource_instance in assoc(link, :datasource_instance),
      as: :datasource_instance
    )
    |> preload([:user, datasource_instance: [:datasource]])
  end
end
