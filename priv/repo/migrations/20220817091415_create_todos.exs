defmodule LiveSup.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :description, :string, null: false
      add :project_id, references(:projects, type: :uuid)
      add :author_id, references(:users, type: :uuid)

      timestamps()
    end
  end
end
