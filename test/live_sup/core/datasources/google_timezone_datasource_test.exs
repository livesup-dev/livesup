defmodule LiveSup.Test.Core.Datasources.GoogleTimezoneDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Core.Datasources.GoogleTimezoneDatasource

  @response """
  {
    "dstOffset": 0,
    "rawOffset": -28800,
    "status": "OK",
    "timeZoneId": "America/Los_Angeles",
    "timeZoneName": "Pacific Standard Time"
  }
  """

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @tag datasource: true, google_timezone_datasource: true
  test "Get timezone from location", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/maps/api/timezone/json", fn conn ->
      Plug.Conn.resp(conn, 200, @response)
    end)

    {:ok, data} =
      GoogleTimezoneDatasource.get_timezone(
        %{
          "key" => "xxx",
          "lat" => "39.6034810",
          "lng" => "-119.6822510"
        },
        url: endpoint_url(bypass.port)
      )

    assert %{
             time_zone_id: "America/Los_Angeles",
             time_zone_name: "Pacific Standard Time"
           } = data
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
