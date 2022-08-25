defmodule LiveSup.Repo.Migrations.AddArchivedColumn do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add(:archived, :boolean, null: false, default: false)
      add(:archived_at, :naive_datetime)
    end
  end
end
