defmodule LiveSup.Test.GroupsFixtures do
  alias LiveSup.Core.Groups

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Projects` context.
  """
  def group_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(ramdom_attrs())
    |> Groups.create()
    |> elem(1)
  end

  def administrator_group_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(admin_default_attrs())
    |> Groups.create()
    |> elem(1)
  end

  def all_users_group_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(all_users_default_attrs())
    |> Groups.create()
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

  defp ramdom_attrs() do
    id = System.unique_integer()

    %{
      name: "Random-#{id}",
      slug: "random-#{id}",
      internal: false
    }
  end
end
