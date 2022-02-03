defmodule LiveSup.Test.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """

  def administrator_group_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(admin_default_attrs())
    |> LiveSup.Core.Groups.create()
    |> elem(1)
  end

  def all_users_group_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(all_users_default_attrs())
    |> LiveSup.Core.Groups.create()
    |> elem(1)
  end

  defp admin_default_attrs() do
    %{
      name: "Administrators",
      slug: "administrators",
      internal: true
    }
  end

  defp all_users_default_attrs() do
    %{
      name: "All Users",
      slug: "all-users",
      internal: true
    }
  end
end
