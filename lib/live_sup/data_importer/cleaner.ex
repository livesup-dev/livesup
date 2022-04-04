defmodule LiveSup.DataImporter.Cleaner do
  alias LiveSup.Core.{Projects, Dashboards, Teams}

  def clean(data) do
    data
    |> clean_projects()
    |> clean_teams()
  end

  def clean_projects(%{"remove_existing_projects" => true} = data) do
    Projects.all()
    |> Enum.each(fn project ->
      project
      |> Dashboards.delete_all()

      {:ok, _proj} =
        project
        |> Projects.delete()
    end)

    data
  end

  def clean_projects(data), do: data

  def clean_teams(%{"remove_existing_teams" => true} = data) do
    Teams.all()
    |> Enum.each(fn team ->
      team
      |> Teams.delete_members()

      team
      |> Teams.delete()
    end)

    data
  end

  def clean_teams(data), do: data
end
