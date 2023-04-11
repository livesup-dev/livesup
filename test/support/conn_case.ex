defmodule LiveSupWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use LiveSupWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import LiveSupWeb.ConnCase

      alias LiveSupWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint LiveSupWeb.Endpoint

      use LiveSupWeb, :verified_routes

      import LiveSup.Test.Setups
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(LiveSup.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(LiveSup.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.
      setup :register_and_log_in_user
  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = LiveSup.Test.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.
  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = LiveSup.Core.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  @doc """
  Setup helper that registers and assigns a valid jwt for users.

    setup :create_user_and_assign_valid_jwt

  It stores an updated connection and a registered user in the
  test context.
  """
  def create_user_and_assign_valid_jwt(%{conn: conn}) do
    user = LiveSup.Test.AccountsFixtures.user_fixture()
    {:ok, jwt, _full_claims} = LiveSupWeb.Api.Guardian.encode_and_sign(user, %{})

    conn =
      Plug.Conn.put_req_header(conn, "authorization", "bearer: " <> jwt)
      |> Plug.Conn.put_req_header("accept", "application/json")

    {:ok, conn: conn, user: user}
  end
end
