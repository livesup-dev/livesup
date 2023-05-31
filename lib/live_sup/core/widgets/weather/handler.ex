defmodule LiveSup.Core.Widgets.Weather.Handler do
  alias LiveSup.Core.Datasources.WeatherApiDatasource

  def get_data(%{"key" => _key, "location" => _location} = args) do
    args
    |> WeatherApiDatasource.get_current_weather()
    |> process_response()
  end

  defp process_response({:error, %{"error" => %{"code" => code, "message" => message}}}),
    do: {:error, "#{code}: #{message}"}

  defp process_response({:error, error}), do: {:error, error}
  defp process_response({:ok, response}), do: {:ok, response}
end
