defmodule LiveSup.Repo.Migrations.AddOrder do
  use Ecto.Migration

  def change do
    alter table("dashboards_widgets") do
      add :order, :integer, default: 0
    end
  end
end
