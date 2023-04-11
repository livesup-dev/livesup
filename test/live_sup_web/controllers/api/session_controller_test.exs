defmodule LiveSupWeb.Api.SessionControllerTest do
  use LiveSupWeb.ConnCase, async: true

  import LiveSup.Test.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "POST /api/session" do
    @describetag :session

    test "with no credentials user can't login", %{conn: conn} do
      conn = post(conn, ~p"/api/sessions", email: nil, password: nil)
      assert %{"message" => "User could not be authenticated"} = json_response(conn, 401)
    end

    test "with invalid password user cant login", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/api/sessions",
          email: user.email,
          password: "wrongpass"
        )

      assert %{"message" => "User could not be authenticated"} = json_response(conn, 401)
    end

    test "with valid password user can login", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/api/sessions",
          email: user.email,
          password: valid_user_password()
        )

      assert %{
               "data" => %{"token" => "" <> _},
               "message" => "You are successfully logged in" <> _
             } = json_response(conn, 200)
    end
  end
end
