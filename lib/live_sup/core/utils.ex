defmodule LiveSup.Core.Utils do
  alias LiveSup.Core.Datasources.GoogleTimezoneDatasource

  def convert_to_module(module_name) do
    "Elixir.#{module_name}"
    |> String.to_existing_atom()
  end

  def get_timezone_from_location(lat, lng) do
    key = LiveSup.Config.google_map_key!()
    GoogleTimezoneDatasource.get_timezone(%{"key" => key, "lat" => lat, "lng" => lng})
  end
end
