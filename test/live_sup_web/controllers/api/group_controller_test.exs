defmodule LiveSupWeb.Api.GroupControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.GroupsFixtures

  alias LiveSup.Schemas.Group

  @create_attrs %{
    internal: true,
    name: "some name"
  }
  @update_attrs %{
    internal: false,
    name: "some updated name"
  }
  @invalid_attrs %{internal: nil, name: nil, slug: nil}

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    @describetag :group_request
    setup do
      %{group: group_fixture()}
    end

    test "lists all groups", %{conn: conn, group: group} do
      conn = get(conn, Routes.api_group_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "name" => group.name,
                 "slug" => group.slug,
                 "id" => group.id,
                 "internal" => false
               }
             ]
    end
  end

  describe "create group" do
    @describetag :group_request
    test "renders group when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_group_path(conn, :create), group: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_group_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "internal" => true,
               "name" => "some name",
               "slug" => "some-name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_group_path(conn, :create), group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update group" do
    setup [:create_group]

    test "renders group when data is valid", %{conn: conn, group: %Group{id: id} = group} do
      conn = put(conn, Routes.api_group_path(conn, :update, group), group: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_group_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "internal" => false,
               "name" => "some updated name",
               "slug" => _
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, group: group} do
      conn = put(conn, Routes.api_group_path(conn, :update, group), group: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete group" do
    setup [:create_group]

    test "deletes chosen group", %{conn: conn, group: group} do
      conn = delete(conn, Routes.api_group_path(conn, :delete, group))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_group_path(conn, :show, group))
      end
    end
  end

  defp create_group(_) do
    group = group_fixture()
    %{group: group}
  end
end
