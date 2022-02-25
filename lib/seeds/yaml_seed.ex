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
      |> get_or_create_project()
      |> import_dashboards(project_attrs)
    end)
  end

  defp get_or_create_project(%{"id" => id} = attrs) do
    Projects.get(id) || Projects.create_public_project(attrs)
  end

  defp import_dashboards({:ok, %Project{} = project}, %{"dashboards" => dashboards}) do
    dashboards
    |> Enum.each(fn dashboard_attrs ->
      project
      |> get_or_create_dashboard(dashboard_attrs)
    end)
  end

  def get_or_create_dashboard(project, %{"id" => id} = attrs) do
    case Dashboards.get(id) do
      {:error, :not_found} -> Dashboards.create(project, attrs)
      {:ok, dashboard} -> {:ok, dashboard}
    end
  end

  # defp import_dashboards(project, _), do: nil

  defp parse_yaml(data) do
    {:ok, parsed_data} = YamlElixir.read_from_string(data)
    parsed_data
  end
end
