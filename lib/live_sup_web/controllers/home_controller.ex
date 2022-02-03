defmodule LiveSupWeb.HomeController do
  use LiveSupWeb, :controller

  def index(conn, _params) do
    # render(conn, "index.html")
    conn
    |> redirect(to: "/projects")
  end
end
