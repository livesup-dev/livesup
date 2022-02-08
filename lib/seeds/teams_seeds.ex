defmodule LiveSup.Seeds.TeamsSeeds do
  alias LiveSup.Core.{Accounts, Teams}

  def seed, do: insert_data()

  defp insert_data do
    Teams.get_by_slug("team-a")
    |> build_team()
  end

  defp build_team(nil) do
    team =
      %{name: "Team A", slug: "team-a"}
      |> Teams.create!()

    ["john@summing-up.com", "emiliano@summing-up.com"]
    |> Enum.each(fn email ->
      user = Accounts.get_user_by_email(email)
      Teams.add_member(team, user)
    end)
  end

  defp build_team(_team), do: nil
end
