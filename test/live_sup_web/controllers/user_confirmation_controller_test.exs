defmodule LiveSupWeb.UserConfirmationControllerTest do
  use LiveSupWeb.ConnCase, async: true

  alias LiveSup.Core.Accounts
  alias LiveSup.Schemas.{UserToken, User}
  alias LiveSup.Repo
  import LiveSup.Test.AccountsFixtures

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    %{user: user_fixture()}
  end

  describe "GET /users/confirm" do
    @describetag :skip
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, ~p"/users/confirm")
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /users/confirm" do
    @describetag :skip
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/confirm", %{
          "user" => %{"email" => user.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(UserToken, user_id: user.id).context == "confirm"
    end

    test "does not send confirmation token if account is confirmed", %{conn: conn, user: user} do
      Repo.update!(User.confirm_changeset(user))

      conn =
        post(conn, ~p"/users/confirm", %{
          "user" => %{"email" => user.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/users/confirm", %{
          "user" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(UserToken) == []
    end
  end

  describe "GET /users/confirm/:token" do
    @describetag :skip
    test "confirms the given token once", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      conn = get(conn, ~p"/users/confirm/#{token}")
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Account confirmed successfully"
      assert Accounts.get_user!(user.id).confirmed_at
      refute get_session(conn, :user_token)
      assert Repo.all(UserToken) == []

      # When not logged in
      conn = get(conn, ~p"/users/confirm/#{token}")
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Account confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_user(user)
        |> get(~p"/users/confirm/#{token}")

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, user: user} do
      conn = get(conn, ~p"/users/confirm/#{"oops"}")
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Account confirmation link is invalid or it has expired"
      refute Accounts.get_user!(user.id).confirmed_at
    end
  end
end
