defmodule LiveSup.DataImporter.Importer do
  alias LiveSup.DataImporter.{
    ProjectImporter,
    TeamImporter,
    MetricImporter,
    Cleaner,
    UserImporter
  }

  def import(data) do
    data
    |> parse_yaml()
    |> Cleaner.clean()
    |> ProjectImporter.import()
    |> TeamImporter.import()
    |> UserImporter.import()
    |> MetricImporter.import()

    :ok
  end

  defp parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
