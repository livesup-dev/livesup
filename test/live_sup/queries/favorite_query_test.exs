defmodule LiveSup.Queries.FavoriteQueryTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  import LiveSup.Test.Setups
  alias LiveSup.Queries.FavoriteQuery
  alias LiveSup.Schemas.Favorite
  alias LiveSup.Test.{ProjectsFixtures, AccountsFixtures}

  setup [:setup_user, :setup_project]

  @tag :favorite_create
  test "create/1 creates a new favorite", %{
    user: %{id: user_id},
    project: %{id: project_id}
  } do
    attrs = %{user_id: user_id, entity_id: project_id, entity_type: "project"}
    {:ok, favorite} = FavoriteQuery.create(attrs)
    assert favorite.user_id == user_id
    assert favorite.entity_id == project_id
    assert favorite.entity_type == Favorite.project_type()
  end

  describe "delete favorites" do
    @describetag :favorites

    setup [:setup_favorite]

    @tag :favorite_delete
    test "deleting favorite", %{favorite: favorite} do
      {:ok, _favorite} = favorite |> FavoriteQuery.delete()

      assert FavoriteQuery.get(favorite.id) == nil
    end
  end

  describe "get favorites" do
    @describetag :favorites

    setup [:setup_user, :setup_project, :setup_favorite, :setup_other_favorites]

    @tag :favorite_all
    test "all/1 returns all favorites for a user", %{user: %{id: user_id}} do
      favorites = FavoriteQuery.all(user_id)
      assert length(favorites) == 1
      assert Enum.all?(favorites, fn f -> f.user_id == user_id end)
    end

    @tag :favorite_exists
    test "exists?/2", %{user: %{id: user_id} = user, project: project} do
      assert FavoriteQuery.exists?(user_id, project)
      assert FavoriteQuery.exists?(user, project)
    end

    @tag :favorite_toggle
    test "toggle/2", %{user: %{id: user_id} = user, project: project} do
      assert FavoriteQuery.toggle(user_id, project) == false
      assert FavoriteQuery.exists?(user, project) == false
      assert FavoriteQuery.toggle(user_id, project)
      assert FavoriteQuery.exists?(user, project)
    end

    def setup_other_favorites(context) do
      project = ProjectsFixtures.project_fixture()
      user = AccountsFixtures.user_fixture()
      setup_favorite(%{user: user, project: project})

      context
    end
  end
end
