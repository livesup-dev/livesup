defmodule LiveSupWeb.Api.UserView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      avatar_url: user.avatar_url,
      email: user.email,
      confirmed_at: user.confirmed_at,
      location: user.location
    }
  end
end
