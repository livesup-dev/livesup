defmodule LiveSup.Test.Core.Datasources.ChuckNorrisApiDatasourceTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Datasources.ChuckNorrisApiDatasource

  @response """
  {
    "icon_url" : "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
    "id" : "xAAGEowVTaaN5P0_-LvBSA",
    "url" : "",
    "value" : "Chuck Norris smokes chains."
  }
  """

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @tag datasource: true, chuck_norris_api_datasource: true
  test "Get data from http endpoint", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "jokes/random", fn conn ->
      Plug.Conn.resp(conn, 200, @response)
    end)

    {:ok, data} =
      ChuckNorrisApiDatasource.get_joke(%{
        "url" => endpoint_url(bypass.port, "jokes/random")
      })

    assert "Chuck Norris smokes chains." = data
  end

  defp endpoint_url(port, endpoint), do: "http://localhost:#{port}/#{endpoint}"
end
