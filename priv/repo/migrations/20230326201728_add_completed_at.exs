defmodule LiveSup.Repo.Migrations.AddCompletedAt do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :completed_at, :utc_datetime, null: true
    end
  end
end
