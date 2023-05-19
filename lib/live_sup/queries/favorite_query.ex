defmodule LiveSup.Queries.FavoriteQuery do
  import Ecto.Query

  alias LiveSup.Schemas.{Favorite, Todo, Dashboard, Project, User}
  alias LiveSup.Repo

  def all(user_id) do
    base()
    |> where([f], f.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Get a Favorite
  """
  def get!(%Favorite{id: favorite_id}) do
    base()
    |> Repo.get!(favorite_id)
  end

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  @doc """
  Get a Favorite
  """
  def get(%Favorite{id: favorite_id}) do
    base()
    |> Repo.get(favorite_id)
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  @doc """
  Creates a Favorite
  """
  def create(attrs) do
    %Favorite{}
    |> Favorite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Update a Favorite
  """
  def update(model, attrs) do
    model
    |> Favorite.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def delete(user_id, entity_id, entity_type) do
    from(f in Favorite)
    |> where(
      [f],
      f.user_id == ^user_id and f.entity_id == ^entity_id and f.entity_type == ^entity_type
    )
    |> Repo.delete_all()
  end

  def exists?(user_id, %Project{id: id}), do: exists?(user_id, id, Favorite.project_type())
  def exists?(user_id, %Todo{id: id}), do: exists?(user_id, id, Favorite.todo_type())

  def exists?(user_id, %Dashboard{id: id}),
    do: exists?(user_id, id, Favorite.dashboard_type())

  def exists?(%User{id: user_id}, entity_id, entity_type),
    do: exists?(user_id, entity_id, entity_type)

  def exists?(user_id, entity_id, entity_type) do
    base()
    |> where(
      [f],
      f.user_id == ^user_id and f.entity_id == ^entity_id and f.entity_type == ^entity_type
    )
    |> Repo.exists?()
  end

  def toggle(user_id, %Project{id: id}), do: toggle(user_id, id, Favorite.project_type())
  def toggle(user_id, %Todo{id: id}), do: toggle(user_id, id, Favorite.todo_type())

  def toggle(user_id, %Dashboard{id: id}),
    do: toggle(user_id, id, Favorite.dashboard_type())

  def toggle(%User{id: user_id}, entity_id, entity_type),
    do: toggle(user_id, entity_id, entity_type)

  def toggle(user_id, entity_id, entity_type) do
    case exists?(user_id, entity_id, entity_type) do
      true ->
        delete(user_id, entity_id, entity_type)
        false

      false ->
        {:ok, favorite} =
          create(%{user_id: user_id, entity_id: entity_id, entity_type: entity_type})

        true
    end
  end

  def base, do: from(Favorite, as: :favorite, preload: [:user])
end
