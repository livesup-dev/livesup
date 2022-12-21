defmodule LiveSupWeb.OAuthController do
  use LiveSupWeb, :controller
  plug(Ueberauth)

  alias LiveSup.Core.Accounts
  alias LiveSupWeb.UserAuth

  def callback(
        %{assigns: %{ueberauth_auth: %{info: user_info}}} = conn,
        %{
          "provider" => _provider
        } = params
      ) do
    # params |> dbg
    # conn |> dbg
    user_params = %{
      email: user_info.email,
      first_name: user_info.first_name,
      last_name: user_info.last_name,
      avatar_url: user_info.image
    }

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, %{"error_description" => error}) do
    conn
    |> put_flash(:error, "Authentication failed: #{error}")
    |> redirect(to: "/sign-in")
  end
end
