defmodule LiveSup.Repo.Migrations.AddLinksTable do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid)
      add :datasource_id, references(:datasources, type: :uuid)
      add :settings, :map, default: "{}"

      timestamps()
    end

    create(index(:links, [:user_id, :datasource_id], unique: true))
  end
end
