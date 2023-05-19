defmodule LiveSup.Repo.Migrations.CreateFavoritesTable do
  use Ecto.Migration

  def change do
    create table(:favorites, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :entity_id, :uuid, null: false
      add :entity_type, :string, null: false

      timestamps()
    end

    create index(:favorites, [:user_id, :entity_id, :entity_type], unique: true)
  end
end
