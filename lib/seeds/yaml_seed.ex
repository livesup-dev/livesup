defmodule LiveSup.Seeds.YamlSeed do
  alias LiveSup.Core.Projects

  def seed(data) do
    data
    |> parse_yaml()
    |> import_projects()

    :ok
  end

  defp import_projects(%{"projects" => projects}) do
    projects
    |> Enum.each(fn project_attrs ->
      project_attrs
      |> Projects.create_public_project()
    end)
  end

  defp parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
