defmodule LiveSup.DataImporter.Importer do
  alias LiveSup.DataImporter.{ProjectImporter, TeamImporter, MetricImporter}

  def import(data) do
    data
    |> parse_yaml()
    |> ProjectImporter.import()
    |> TeamImporter.import()
    |> MetricImporter.import()

    :ok
  end

  defp parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
