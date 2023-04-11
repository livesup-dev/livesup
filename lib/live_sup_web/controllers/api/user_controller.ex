defmodule LiveSupWeb.Api.UserController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Users
  alias LiveSup.Schemas.User

  def index(conn, _params) do
    users = Users.all()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/users/#{user.id}")
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get!(id)

    with {:ok, %User{} = user} <- Users.update(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get!(id)

    with {:ok, %User{}} <- Users.delete(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
