defmodule LiveSup.Queries.UserQuery do
  alias LiveSup.Schemas.{TeamMember, User}
  alias LiveSup.Repo
  import Ecto.Query

  def get_system_account(identifier) do
    base()
    |> where([u], u.system == true)
    |> where([u], u.system_identifier == ^identifier)
    |> Repo.one()
  end

  def get_system_account!(identifier) do
    base()
    |> where([u], u.system == true)
    |> where([u], u.system_identifier == ^identifier)
    |> Repo.one!()
  end

  def all do
    base()
    |> Repo.all()
  end

  def get!(id) do
    base()
    |> preload(:team_members)
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

  def create_with_id(data) do
    %User{}
    |> User.internal_registration_changeset(data)
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

  def get_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def onboard!(%User{} = model) do
    model
    |> User.update_changeset(%{state: "onboarded"})
    |> Repo.update!()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def delete_all() do
    base()
    |> Repo.delete_all()
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
