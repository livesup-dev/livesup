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

alias LiveSup.Seeds.{
  DatasourcesSeeds,
  WidgetsSeeds,
  GroupsSeeds,
  UsersSeeds,
  TeamsSeeds,
  ProjectsSeeds,
  InternalDataSeeds
}

defmodule LiveSup.Seeds do
  def seed() do
    # Application.load(:live_sup)

    DatasourcesSeeds.seed()
    WidgetsSeeds.seed()
    GroupsSeeds.seed()
    UsersSeeds.seed()
    TeamsSeeds.seed()
    ProjectsSeeds.seed()
    InternalDataSeeds.seed()
  end
end
