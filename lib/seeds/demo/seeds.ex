alias LiveSup.Seeds.{
  TeamsSeeds,
  ProjectsSeeds,
  MetricsSeeds
}

defmodule LiveSup.Seeds.Demo do
  def seed() do
    MetricsSeeds.seed()
    TeamsSeeds.seed()
    ProjectsSeeds.seed()
  end
end
