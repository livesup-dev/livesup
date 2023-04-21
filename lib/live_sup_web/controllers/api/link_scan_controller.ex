defmodule LiveSupWeb.Api.LinkScanController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Core.LinksScanners.Scanner

  def create(conn, %{"user_id" => user_id, "datasource" => datasource}) do
    with {:ok, links} <- Scanner.scan(user_id, datasource) do
      conn
      |> put_status(:created)
      |> render(:index, links: links)
    end
  end
end
