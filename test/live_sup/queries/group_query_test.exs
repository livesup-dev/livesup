defmodule LiveSup.Tests.Queries.GroupQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Queries.GroupQuery

  setup [:setup_groups]

  describe "managing internal queries for groups" do
    @describetag :group_query

    test "return administrators group", %{admin_group: %{id: administrators_group_id}} do
      administrator_group = GroupQuery.get_administrator_group()
      assert administrator_group.id == administrators_group_id
    end

    test "return all users group", %{all_users_group: %{id: all_users_group_id}} do
      all_users_group = GroupQuery.get_all_users_group()
      assert all_users_group.id == all_users_group_id
    end
  end
end
