defmodule LiveSup.Queries.UserQuery do
  alias LiveSup.Schemas.{TeamMember, User}
  alias LiveSup.Repo
  import Ecto.Query

  def all do
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

  def create!(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert!()
  end

  def create(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert()
  end

  def update(%User{} = model, attrs) do
    model
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update!(%User{} = model, attrs) do
    model
    |> User.update_changeset(attrs)
    |> Repo.update!()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def search(%{value: value, not_in_team: team_id}) do
    search_for = "%#{value}%"

    team_members_set =
      from(
        tm in TeamMember,
        where: tm.team_id == ^team_id,
        select: tm.user_id
      )

    base()
    |> where(
      [u],
      ilike(u.email, ^search_for) or
        ilike(u.first_name, ^search_for) or
        ilike(u.last_name, ^search_for)
    )
    |> where([u], u.id not in subquery(team_members_set))
    |> Repo.all()
  end

  def search(value) when is_binary(value) do
    search_for = "%#{value}%"

    base()
    |> where(
      [u],
      ilike(u.email, ^search_for) or
        ilike(u.first_name, ^search_for) or
        ilike(u.last_name, ^search_for)
    )
    |> Repo.all()
  end

  def base, do: from(User, as: :user)
end
