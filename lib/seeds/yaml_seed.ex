defmodule LiveSup.Seeds.YamlSeed do
  alias LiveSup.Core.{Projects, Dashboards}
  alias LiveSup.Schemas.Project

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
      |> import_dashboards(project_attrs)
    end)
  end

  defp import_dashboards(%Project{} = project, %{"dashboards" => dashboards}) do
    dashboards
    |> Enum.each(fn dashboard_attrs ->
      project
      |> Dashboards.create(dashboard_attrs)
    end)
  end

  defp import_dashboards(project, _), do: nil

  defp parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
