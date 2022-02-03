defmodule LiveSup.Repo.Migrations.AddUiSettings do
  use Ecto.Migration

  def change do
    alter table("widgets") do
      add :ui_settings, :map, default: "{}"
    end
  end
end
