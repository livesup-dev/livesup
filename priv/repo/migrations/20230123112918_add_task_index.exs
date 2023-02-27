defmodule LiveSup.Repo.Migrations.AddTaskIndex do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify(:created_by_id, :uuid, null: false)
    end
  end
end
