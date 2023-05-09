defmodule LiveSup.DataImporter.Importer do
  alias LiveSup.DataImporter.{
    ProjectImporter,
    TeamImporter,
    MetricImporter,
    Cleaner,
    UserImporter,
    NoteImporter,
    TodoImporter
  }

  def perform(data) do
    data
    |> parse_yaml()
    |> Cleaner.clean()
    |> UserImporter.perform()
    |> ProjectImporter.perform()
    |> TeamImporter.perform()
    |> MetricImporter.perform()
    |> NoteImporter.perform()
    |> TodoImporter.perform()

    :ok
  end

  def parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
