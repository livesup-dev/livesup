defmodule Mix.Tasks.LiveSup.Seed do
  use Mix.Task

  @shortdoc "Seeds the database"
  def run(_) do
    Mix.Task.run("app.start", [])
    LiveSup.Seeds.seed()
  end
end
