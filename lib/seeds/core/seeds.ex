alias LiveSup.Seeds.Core.{
  DatasourcesSeeds,
  WidgetsSeeds,
  GroupsSeeds,
  InternalDataSeeds
}

defmodule LiveSup.Seeds.Core do
  def seed() do
    DatasourcesSeeds.seed()
    WidgetsSeeds.seed()
    GroupsSeeds.seed()
    InternalDataSeeds.seed()
  end
end
