defmodule LiveSupWeb.Api.GroupController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.Groups
  alias LiveSup.Schemas.Group

  def index(conn, _params) do
    groups = Groups.all()
    render(conn, "index.json", groups: groups)
  end

  def create(conn, %{"group" => group_params}) do
    with {:ok, %Group{} = group} <- Groups.create(group_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/groups/#{group.id}")
      |> render("show.json", group: group)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Groups.get!(id)
    render(conn, "show.json", group: group)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Groups.get!(id)

    with {:ok, %Group{} = group} <- Groups.update(group, group_params) do
      render(conn, "show.json", group: group)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Groups.get!(id)

    with {:ok, %Group{}} <- Groups.delete(group) do
      send_resp(conn, :no_content, "")
    end
  end
end
