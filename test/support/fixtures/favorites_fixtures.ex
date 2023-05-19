defmodule LiveSup.Test.FavoritesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  alias LiveSup.Core.Favorites

  def favorite_fixture(attrs \\ %{}) do
    attrs
    |> Favorites.create()
    |> elem(1)
  end
end
