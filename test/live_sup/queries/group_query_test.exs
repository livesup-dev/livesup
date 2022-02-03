defmodule LiveSup.Tests.Queries.GroupQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Schemas.Group
  alias LiveSup.Queries.GroupQuery
  alias LiveSup.Repo

  setup do
    administrators_group =
      Group.changeset(%Group{}, %{
        name: "Administrators",
        slug: "administrators",
        internal: true
      })
      |> Repo.insert!()

    all_users_group =
      Group.changeset(%Group{}, %{name: "All Users", slug: "all-users", internal: true})
      |> Repo.insert!()

    %{administrators_group: administrators_group, all_users_group: all_users_group}
  end

  describe "managing internal queries for groups" do
    @describetag :group_query

    test "return administrators group", %{administrators_group: %{id: administrators_group_id}} do
      administrator_group = GroupQuery.get_administrator_group()
      assert administrator_group.id == administrators_group_id
    end

    test "return all users group", %{all_users_group: %{id: all_users_group_id}} do
      all_users_group = GroupQuery.get_all_users_group()
      assert all_users_group.id == all_users_group_id
    end
  end
end
