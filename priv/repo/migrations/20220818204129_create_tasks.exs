defmodule LiveSup.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:description, :string, null: false)
      add(:notes, :string, null: true)
      add(:todo_id, references(:todos, type: :uuid), null: false)
      add(:assigned_to_id, references(:users, type: :uuid))
      add(:created_by_id, references(:users, type: :uuid))
      add(:completed, :boolean, null: false, default: false)
      add(:due_on, :utc_datetime, null: true)
      add(:position, :integer, null: false, default: 0)
      add(:parent_id, references(:tasks, type: :uuid), null: true)

      timestamps()
    end

    rename table(:todos), :author_id, to: :created_by_id

    alter table(:todos) do
      add(:position, :integer, null: false, default: 0)
    end
  end
end
