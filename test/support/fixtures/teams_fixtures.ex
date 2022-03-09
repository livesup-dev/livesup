defmodule LiveSup.Test.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Teams` context.
  """

  alias LiveSup.Core.Teams

  def team_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(ramdom_attrs())
    |> Teams.create()
    |> elem(1)
  end

  defp ramdom_attrs() do
    id = System.unique_integer()

    %{
      name: "Random-#{id}"
    }
  end
end
