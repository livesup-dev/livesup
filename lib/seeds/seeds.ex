# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveSup.Repo.insert!(%LiveSup.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Mix.Tasks.LiveSup.Seeds do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start", [])

    Mix.env()
    |> LiveSup.Seeds.DatasourcesSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.WidgetsSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.GroupsSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.UsersSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.TeamsSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.ProjectsSeeds.seed()

    Mix.env()
    |> LiveSup.Seeds.InternalDataSeeds.seed()
  end
end
