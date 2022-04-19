alias LiveSup.Seeds.Core.{
  DatasourcesSeeds,
  WidgetsSeeds,
  GroupsSeeds,
  InternalDataSeeds,
  UsersSeeds
}

defmodule LiveSup.Seeds.Core do
  def seed() do
    DatasourcesSeeds.seed()
    WidgetsSeeds.seed()
    GroupsSeeds.seed()
    InternalDataSeeds.seed()
    UsersSeeds.seed()
  end
end
