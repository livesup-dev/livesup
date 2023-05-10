defmodule LiveSup.Repo.Migrations.UpgradeObanToV11 do
  use Ecto.Migration

  def up, do: Oban.Migration.up(version: 11)

  def down, do: Oban.Migration.down(version: 11)
end
