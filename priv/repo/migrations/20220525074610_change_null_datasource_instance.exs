defmodule LiveSup.Repo.Migrations.ChangeNullDatasourceInstance do
  use Ecto.Migration

  def change do
    alter table(:links) do
      modify :datasource_instance_id, :uuid, null: false
    end
  end
end
