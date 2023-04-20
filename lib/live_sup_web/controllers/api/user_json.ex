defmodule LiveSupWeb.Api.UserJSON do
  alias LiveSup.Schemas.User

  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      avatar_url: user.avatar_url,
      email: user.email,
      confirmed_at: user.confirmed_at,
      location: user.location,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
