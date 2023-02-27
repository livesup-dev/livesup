defmodule LiveSup.Repo.Migrations.AddDatasourcesTodo do
  use Ecto.Migration

  def change do
    create table(:todo_datasources, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:todo_id, references(:todos, on_delete: :delete_all, type: :uuid), null: false)
      add(:settings, :map, default: "{}", null: false)
      add(:last_run_at, :utc_datetime, null: true)

      add(
        :datasource_instance_id,
        references(:datasource_instances, on_delete: :nilify_all, type: :uuid),
        null: false
      )

      timestamps()
    end
  end
end
