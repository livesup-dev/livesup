defmodule LiveSup.Repo.Migrations.AddTypeToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add(:datasource_slug, :string, null: true)
    end
  end
end
