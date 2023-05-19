defmodule LiveSup.Core.Favorites do
  @moduledoc """
  The favorites context.
  """

  alias LiveSup.Queries.{TodoQuery, ProjectQuery, DashboardQuery, FavoriteQuery}
  alias LiveSup.Schemas.{Favorite, User, Project, Todo, Dashboard}

  defdelegate create(attrs), to: FavoriteQuery
  defdelegate delete(favorite), to: FavoriteQuery

  def all(%User{id: user_id}) do
    user_id
    |> FavoriteQuery.all()
    |> Enum.map(fn favorite ->
      favorite
      |> Map.put(
        :entity,
        get_entity(favorite)
      )
    end)
  end

  @todo_type Favorite.todo_type()
  @dashboard_type Favorite.dashboard_type()
  @project_type Favorite.project_type()

  defp get_entity(%{entity_type: @todo_type, entity_id: entity_id}), do: TodoQuery.get(entity_id)

  defp get_entity(%{entity_type: @dashboard_type, entity_id: entity_id}),
    do: DashboardQuery.get(entity_id)

  defp get_entity(%{entity_type: @project_type, entity_id: entity_id}),
    do: ProjectQuery.get(entity_id)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite changes.

  ## Examples

      iex> change(favorite)
      %Ecto.Changeset{data: %Favorite{}}

  """
  def change(%Favorite{} = favorite, attrs \\ %{}) do
    Favorite.changeset(favorite, attrs)
  end

  def add(%User{id: user_id}, %Project{id: project_id}) do
    %{
      user_id: user_id,
      entity_id: project_id,
      entity_type: Favorite.project_type()
    }
    |> create()
  end

  def add(%User{id: user_id}, %Todo{id: todo_id}) do
    %{
      user_id: user_id,
      entity_id: todo_id,
      entity_type: Favorite.todo_type()
    }
    |> create()
  end

  def add(%User{id: user_id}, %Dashboard{id: dashboard_id}) do
    %{
      user_id: user_id,
      entity_id: dashboard_id,
      entity_type: Favorite.dashboard_type()
    }
    |> create()
  end
end
