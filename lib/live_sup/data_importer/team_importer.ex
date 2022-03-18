defmodule LiveSup.DataImporter.TeamImporter do
  alias LiveSup.Core.Teams

  def import(%{"teams" => teams}) do
    teams
    |> Enum.each(fn team_attrs ->
      team_attrs
      |> get_or_create_team()
    end)
  end

  def import(_data), do: :ok

  defp get_or_create_team(%{"id" => id} = attrs) do
    Teams.get(id) || Teams.create(attrs)
  end
end
