defmodule LiveSup.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :string, null: false
      add :task_id, references(:tasks, type: :uuid), null: false
      add :created_by_id, references(:users, type: :uuid), null: false

      timestamps()
    end
  end
end
