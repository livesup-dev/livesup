defmodule LiveSup.Seeds.TeamsSeeds do
  use Mix.Task

  alias LiveSup.Core.{Accounts, Teams}

  def run(_) do
    Mix.Task.run("app.start", [])

    Mix.env()
    |> seed()
  end

  def seed(:dev) do
    insert_data()
  end

  def seed(:prod) do
    insert_data()
  end

  defp insert_data do
    team =
      %{name: "Team A", slug: "team-a"}
      |> Teams.create!()

    ["john@summing-up.com", "emiliano@summing-up.com"]
    |> Enum.each(fn email ->
      user = Accounts.get_user_by_email(email)
      Teams.add_member(team, user)
    end)
  end
end
