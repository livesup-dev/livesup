defmodule LiveSup.Repo.Migrations.ChangeLinksColumns do
  use Ecto.Migration

  def change do
    drop_if_exists index(:links, [:user_id, :datasource_id])

    alter table(:links) do
      remove :datasource_id
    end

    alter table(:links) do
      add :datasource_instance_id, references(:datasource_instances, type: :uuid)
    end

    create(index(:links, [:user_id, :datasource_instance_id], unique: true))
  end
end
