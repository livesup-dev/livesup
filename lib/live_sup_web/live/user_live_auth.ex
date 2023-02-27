defmodule LiveSupWeb.UserLiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  alias LiveSup.Core.Accounts

  def on_mount(
        :default,
        _params,
        %{"user_token" => user_token} = _session,
        socket
      ) do
    user = Accounts.get_user_by_session_token(user_token)

    socket =
      assign_new(socket, :current_user, fn ->
        user
      end)
      |> assign_new(:permissions, fn ->
        LiveSupWeb.Core.Permissions.get(user)
      end)

    if socket.assigns.current_user.email do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/sign-in")}
    end
  end

  def on_mount(
        :default,
        _params,
        %{"user_token" => user_token} = _session,
        socket
      ) do
    socket =
      assign_new(socket, :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
      end)
      |> assign_new(:scopes, fn ->
        ""
      end)

    if socket.assigns.current_user.email do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/sign-in")}
    end
  end
end
