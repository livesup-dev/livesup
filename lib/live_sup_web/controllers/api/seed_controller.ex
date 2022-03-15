defmodule LiveSupWeb.Api.SeedController do
  use LiveSupWeb, :api_controller

  alias LiveSup.Seeds.YamlSeed

  def create(conn, %{"data" => data}) do
    with :ok <- YamlSeed.seed(data) do
      conn
      |> put_status(:created)
      |> render("show.json", %{result: :ok})
    end
  end
end
