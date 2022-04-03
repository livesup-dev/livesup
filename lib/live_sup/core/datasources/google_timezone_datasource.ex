
defmodule LiveSup.Core.Datasources.GoogleTimezoneDatasource do
  alias LiveSup.Core.Datasources.HttpDatasource

  @url "https://maps.googleapis.com"

  def get_timezone(%{"key" => key, "lat" => lat, "lng" => lng}, args \\ []) do
    url =
      args
      |> Keyword.get(:url, @url)

    case HttpDatasource.get(url: build_url(url, key, lat, lng), headers: []) do
      {:ok, response} -> process(response)
      {:error, error} -> process_error(error)
    end
  end

  defp process_error(error), do: {:error, error}

  defp process(%{"status" => "OK", "timeZoneId" => time_zone_id, "timeZoneName" => time_zone_name}) do
    {:ok,
     %{
       time_zone_id: time_zone_id,
       time_zone_name: time_zone_name
     }}
  end

  defp build_url(url, key, lat, lng) do
    today = LiveSup.Helpers.DateHelper.today_to_unix()
    "#{url}/maps/api/timezone/json?key=#{key}&location=#{lat},#{lng}&timestamp=#{today}"
  end
end
