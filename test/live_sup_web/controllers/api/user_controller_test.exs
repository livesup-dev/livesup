defmodule LiveSupWeb.Api.UserControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.AccountsFixtures

  alias LiveSup.Schemas.User

  @create_attrs %{
    avatar_url: "http://www.images.com/another.jpg",
    confirmed_at: ~N[2022-03-10 09:00:00],
    email: "my@notcoolemail.com",
    first_name: "some first_name",
    last_name: "some last_name",
    password: "some last_name"
  }
  @update_attrs %{
    avatar_url: "http://www.images.com/avatar.jpg",
    confirmed_at: ~N[2022-03-11 09:00:00],
    email: "my@coolemail.com",
    first_name: "some updated first_name",
    last_name: "some updated last_name"
  }
  @invalid_attrs %{
    avatar_url: nil,
    confirmed_at: nil,
    email: nil,
    first_name: nil,
    last_name: nil,
    location: nil
  }

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    @describetag :users_request
    test "lists all users", %{conn: conn, user: user} do
      conn = get(conn, ~p"/api/users")

      assert json_response(conn, 200)["data"] == [
               %{
                 "email" => user.email,
                 "first_name" => user.first_name,
                 "last_name" => user.last_name,
                 "avatar_url" => nil,
                 "confirmed_at" => nil,
                 "id" => user.id,
                 "location" => %{},
                 "inserted_at" => NaiveDateTime.to_iso8601(user.inserted_at),
                 "updated_at" => NaiveDateTime.to_iso8601(user.updated_at)
               }
             ]
    end
  end

  describe "create user" do
    @describetag :users_request
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "avatar_url" => "http://www.images.com/another.jpg",
               "confirmed_at" => _,
               "email" => "my@notcoolemail.com",
               "first_name" => "some first_name",
               "last_name" => "some last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "avatar_url" => "http://www.images.com/avatar.jpg",
               "confirmed_at" => _,
               "email" => "my@coolemail.com",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
