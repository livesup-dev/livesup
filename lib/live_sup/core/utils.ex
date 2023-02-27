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

  def format_date(nil), do: nil

  def format_date(date) when is_binary(date) do
    Timex.parse!(date, "{ISO:Extended:Z}")
    |> Timex.format!("{WDshort}, {Mshort} {D}, {YYYY} {h24}:{m}:{s}")
  end

  def format_date(date) do
    date
    |> Timex.format!("{WDshort}, {Mshort} {D}, {YYYY} {h24}:{m}:{s}")
  end
end
