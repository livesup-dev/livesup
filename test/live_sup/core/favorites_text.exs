defmodule LiveSup.Test.Core.FavoritesTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Core.Favorites
  alias LiveSup.Schemas.Favorite
  import LiveSup.Test.Setups

  describe "favorites" do
    @describetag :favorites

    setup [:setup_user, :setup_project, :setup_favorite, :setup_todo]

    test "all/1 returns all favorites by user", %{
      user: user,
      favorite: favorite,
      project: project
    } do
      assert Favorites.all(user) == [favorite]

      assert favorite.entity.id == favorite.entity.id
    end

    test "get!/1 returns the favorite with given id", %{favorite: favorite} do
      assert Favorites.get!(favorite.id) == favorite
    end

    test "get/1 returns the favorite with given id", %{favorite: favorite} do
      assert favorites.get(favorite.id) == {:ok, favorite}
    end

    test "add/2", %{user: user, project: project} do
      {:ok, favorite} = Favorites.add(user, project)

      assert favorite.entity_id == project.id
      assert favorite.entity_type == Favorite.project_type()
      assert favorite.user_id == user.id
    end

    test "add/2", %{user: user, todo: todo} do
      {:ok, favorite} = Favorites.add(user, todo)

      assert favorite.entity_id == todo.id
      assert favorite.entity_type == Favorite.todo_type()
      assert favorite.user_id == user.id
    end

    test "add/2", %{user: user, dashboard: dashboard} do
      {:ok, favorite} = Favorites.add(user, todo)

      assert favorite.entity_id == dashboard.id
      assert favorite.entity_type == Favorite.dashboard_type()
      assert favorite.user_id == user.id
    end
  end
end
