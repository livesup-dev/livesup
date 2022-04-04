defmodule LiveSup.DataImporter.TeamImporter do
  alias LiveSup.Core.Teams

  def import(%{"teams" => teams} = data) do
    teams
    |> Enum.each(fn team_attrs ->
      team_attrs
      |> get_or_create_team()
    end)

    data
  end

  def import(data), do: data

  defp get_or_create_team(attrs) do
    Teams.upsert(attrs)
  end
end
