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

alias LiveSup.Seeds

defmodule LiveSup.Seeds do
  def seed() do
    Seeds.Core.seed()
  end
end
