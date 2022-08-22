defmodule LiveSup.Repo.Migrations.ChangeReferences do
  use Ecto.Migration

  def change do
    drop constraint("tasks", "tasks_todo_id_fkey")
    drop constraint("tasks", "tasks_created_by_id_fkey")
    drop constraint("tasks", "tasks_parent_id_fkey")
    drop constraint("tasks", "tasks_assigned_to_id_fkey")

    alter table(:tasks) do
      modify(:todo_id, references(:todos, type: :uuid, on_delete: :delete_all), null: false)
      modify(:created_by_id, references(:users, type: :uuid, on_delete: :nilify_all), null: true)
      modify(:assigned_to_id, references(:users, type: :uuid, on_delete: :nilify_all), null: true)
      modify(:parent_id, references(:todos, type: :uuid, on_delete: :nilify_all), null: true)
    end
  end
end
