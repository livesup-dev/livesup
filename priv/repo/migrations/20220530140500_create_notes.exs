defmodule LiveSup.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :content, :string, null: false
      add :slug, :string, default: false, null: false

      timestamps()
    end

    create index(
             :notes,
             [:slug],
             unique: true
           )
  end
end
