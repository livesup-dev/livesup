alias LiveSup.Seeds.Core.{
  DatasourcesSeeds,
  WidgetsSeeds,
  GroupsSeeds,
  UsersSeeds
}

defmodule LiveSup.Seeds.Core do
  def seed() do
    DatasourcesSeeds.seed()
    WidgetsSeeds.seed()
    GroupsSeeds.seed()
    UsersSeeds.seed()
  end
end
