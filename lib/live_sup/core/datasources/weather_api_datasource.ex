defmodule LiveSup.Core.Datasources.WeatherApiDatasource do
  @moduledoc """
    It provides an interface to the Weather API. Under the hood
    it uses the HttpDataSource to perform the requests.
  """
  alias LiveSup.Core.Datasources.HttpDatasource

  # TODO: Find the way to pass this feature flag
  # into the httpdatasource

  @url "https://api.weatherapi.com/v1/current.json"

  def get_current_weather(%{"key" => key, "location" => location, "url" => url}) do
    case HttpDatasource.get(url: build_url(url, location, key), headers: []) do
      {:ok, response} -> process(response)
      {:error, error} -> process_error(error)
    end
  end

  def get_current_weather(%{"key" => _key, "location" => _location} = args) do
    Map.merge(args, %{"url" => @url})
    |> get_current_weather()
  end

  defp process_error(error), do: {:error, error}

  defp process(%{"error" => error}), do: {:error, error}

  defp process(%{"location" => location, "current" => current}) do
    {:ok,
     %{
       location: "#{location["name"]}",
       # We should check the widget instance settings,
       temp: current["temp_c"],
       # We should check the widget instance settings,
       feelslike: current["feelslike_c"],
       is_day: current["is_day"] != 0,
       condition: current["condition"]["text"],
       wind: current["wind_kph"],
       wind_dir: current["wind_dir"],
       humidity: current["humidity"],
       precip: current["precip_mm"],
       icon: current["condition"]["icon"]
     }}
  end

  defp build_url(url, location, key) do
    location = location |> URI.encode()
    "#{url}?key=#{key}&q=#{location}"
  end
end
