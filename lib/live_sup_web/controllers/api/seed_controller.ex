defmodule LiveSupWeb.Api.SeedController do
  use LiveSupWeb, :controller

  alias LiveSup.DataImporter.Importer

  def create(conn, %{"data" => data}) do
    with :ok <- Importer.import(data) do
      conn
      |> put_status(:created)
      |> render(:show, %{result: :ok})
    end
  end
end
