alias LiveSup.Seeds.{
  UsersSeeds,
  TeamsSeeds,
  ProjectsSeeds,
  MetricsSeeds
}

defmodule LiveSup.Seeds.Demo do
  def seed() do
    MetricsSeeds.seed()
    UsersSeeds.seed()
    TeamsSeeds.seed()
    ProjectsSeeds.seed()
  end
end
