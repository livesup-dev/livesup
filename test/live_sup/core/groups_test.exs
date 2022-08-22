defmodule LiveSup.Test.Core.GroupsTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Core.Groups
  alias LiveSup.Schemas.Group

  import LiveSup.Test.AccountsFixtures

  describe "groups" do
    @describetag :groups

    @valid_attrs %{internal: true, name: "some name", slug: "some-name"}
    @invalid_attrs %{name: nil}
    @update_attrs %{name: "some updated name", internal: false}

    setup do
      Groups.delete_all()
      :ok
    end

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Groups.create()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Groups.all() == [group]
    end

    test "get!/1 returns the group with given id" do
      group = group_fixture()
      assert Groups.get!(group.id) == group
    end

    test "create/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Groups.create(@valid_attrs)
      assert group.internal == true
      assert group.name == "some name"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, %Group{} = group} = Groups.update(group, @update_attrs)
      assert group.internal == false
      assert group.name == "some updated name"
    end

    test "update/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update(group, @invalid_attrs)
      assert group == Groups.get!(group.id)
    end

    test "delete/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Groups.delete(group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get!(group.id) end
    end

    test "change/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Groups.change(group)
    end

    test "add user to a group" do
      group = group_fixture()
      user = user_fixture()

      user_group = Groups.add_user(user, group)
      assert user_group.user_id == user.id
      assert user_group.group_id == group.id
    end
  end
end
