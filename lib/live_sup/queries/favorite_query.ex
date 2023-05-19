defmodule LiveSup.Queries.FavoriteQuery do
  import Ecto.Query

  alias LiveSup.Schemas.Favorite
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

  def base, do: from(Favorite, as: :Favorite, preload: [:user])
end
