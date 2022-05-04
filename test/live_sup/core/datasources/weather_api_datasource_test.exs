defmodule LiveSup.Test.Core.Datasources.WeatherApiDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Core.Datasources.WeatherApiDatasource

  @response """
  {
    "location": {
        "name": "London",
        "region": "City of London, Greater London",
        "country": "United Kingdom",
        "lat": 51.52,
        "lon": -0.11,
        "tz_id": "Europe/London",
        "localtime_epoch": 1634940064,
        "localtime": "2021-10-22 23:01"
    },
    "current": {
        "last_updated_epoch": 1634939100,
        "last_updated": "2021-10-22 22:45",
        "temp_c": 10.0,
        "temp_f": 50.0,
        "is_day": 0,
        "condition": {
            "text": "Partly cloudy",
            "icon": "//cdn.weatherapi.com/weather/64x64/night/116.png",
            "code": 1003
        },
        "wind_mph": 6.9,
        "wind_kph": 11.2,
        "wind_degree": 270,
        "wind_dir": "W",
        "pressure_mb": 1024.0,
        "pressure_in": 30.24,
        "precip_mm": 0.1,
        "precip_in": 0.0,
        "humidity": 87,
        "cloud": 75,
        "feelslike_c": 9.0,
        "feelslike_f": 48.1,
        "vis_km": 10.0,
        "vis_miles": 6.0,
        "uv": 1.0,
        "gust_mph": 8.1,
        "gust_kph": 13.0
    }
  }
  """

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @tag datasource: true, weather_api_datasource: true
  test "Get data from http endpoint", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/v1/current.json", fn conn ->
      Plug.Conn.resp(conn, 200, @response)
    end)

    {:ok, data} =
      WeatherApiDatasource.get_current_weather(%{
        "key" => "xxx",
        "location" => "Mahon",
        "url" => endpoint_url(bypass.port, "v1/current.json")
      })

    assert %{
             condition: "Partly cloudy",
             feelslike: 9.0,
             icon: "//cdn.weatherapi.com/weather/64x64/night/116.png",
             is_day: false,
             location: "London",
             temp: 10.0
           } = data
  end

  defp endpoint_url(port, endpoint), do: "http://localhost:#{port}/#{endpoint}"
end
