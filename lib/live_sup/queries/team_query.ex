defmodule LiveSup.Queries.TeamQuery do
  import Ecto.Query

  alias LiveSup.Repo
  alias LiveSup.Schemas.{Team, User, Project}

  def create!(data) do
    %Team{}
    |> Team.changeset(data)
    |> Repo.insert!()
  end

  def create(data) do
    %Team{}
    |> Team.changeset(data)
    |> Repo.insert()
  end

  def upsert(data) do
    %Team{}
    |> Team.changeset(data)
    |> Repo.insert(on_conflict: :nothing)
  end

  def get!(id) do
    base()
    |> preload(team_members: :user)
    |> Repo.get!(id)
  end

  def get(id) do
    base()
    |> preload(team_members: :user)
    |> Repo.get(id)
  end

  def get_by_slug!(slug) do
    base()
    |> where([t], t.slug == ^slug)
    |> Repo.one!()
  end

  def get_by_slug(slug) do
    base()
    |> where([t], t.slug == ^slug)
    |> Repo.one()
  end

  def members(team_id) do
    query =
      from(
        u in User,
        join: tm in assoc(u, :team_members),
        where: tm.team_id == ^team_id
      )

    query
    |> Repo.all()
  end

  def update(%Team{} = model, attrs) do
    model
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def update!(%Team{} = model, attrs) do
    model
    |> Team.changeset(attrs)
    |> Repo.update!()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def by_slug(slug) do
    query =
      from(
        t in Team,
        where: t.slug == ^slug
      )

    query
    |> Repo.one()
  end

  def by_user(%User{id: id}) do
    id |> by_user()
  end

  def by_user(user_id) do
    query =
      from(
        t in Team,
        join: tm in assoc(t, :team_members),
        where: tm.user_id == ^user_id
      )

    query
    |> Repo.all()
  end

  def with_members(team_slug) do
    query =
      from(
        t in Team,
        join: tm in assoc(t, :team_members),
        where: t.slug == ^team_slug,
        preload: [team_members: tm]
      )

    query
    |> Repo.one()
  end

  def all() do
    base()
    |> preload([:team_members])
    |> order_by(asc: :name)
    |> Repo.all()
  end

  def all(%Project{id: project_id}) do
    query =
      from(
        t in Team,
        where: is_nil(t.project_id) or t.project_id == ^project_id,
        left_join: tm in assoc(t, :team_members),
        preload: [team_members: tm]
      )

    query
    |> Repo.all()
  end

  def base, do: from(Team, as: :team)
end
