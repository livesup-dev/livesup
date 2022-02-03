defmodule LiveSupWeb.Live.AuthHelper do
  alias LiveSup.Core.Accounts

  def find_current_user(session) do
    with {:ok, user_token} <- Map.fetch(session, "user_token"),
         user = %{} <- Accounts.get_user_by_session_token(user_token) do
      user
    else
      _ -> nil
    end
  end

  def get_current_user(session, socket) do
    socket.assigns[:current_user] || find_current_user(session)
  end

  def get_current_user(%Plug.Conn{} = conn) do
    conn
    |> Plug.Conn.get_session()
    |> find_current_user()
  end
end
