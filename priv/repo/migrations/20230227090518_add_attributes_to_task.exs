defmodule LiveSup.Repo.Migrations.AddAttributesToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add(:priority, :string)
      add(:tags, {:array, :string})

      add(
        :datasource_instance_id,
        references(:datasource_instances, on_delete: :nilify_all, type: :uuid)
      )

      add(:datasource_slug, :string)
      add(:external_metadata, :map, default: "{}")
    end

    alter table(:tasks) do
      add(:title, :string, null: false)
      add(:external_identifier, :string)
      modify(:description, :text, null: true)
    end

    create(unique_index(:tasks, [:external_identifier, :datasource_instance_id]))
    execute("create index tasks_tags_index on tasks using gin (tags);")
  end
end
