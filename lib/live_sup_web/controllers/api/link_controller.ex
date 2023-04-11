defmodule LiveSupWeb.Api.LinkController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Links
  alias LiveSup.Schemas.Link

  def index(conn, %{"user_id" => user_id}) do
    links = user_id |> Links.get_by_user()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"user_id" => user_id, "link" => link_params}) do
    with {:ok, %Link{} = link} <-
           Links.create(Map.merge(link_params, %{"user_id" => user_id})) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/links/#{link.id}")
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Links.get!(id)
    render(conn, "show.json", link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Links.get!(id)

    with {:ok, %Link{} = link} <-
           Links.update(link, link_params) do
      render(conn, "show.json", link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Links.get!(id)

    with {:ok, %Link{}} <- Links.delete(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
