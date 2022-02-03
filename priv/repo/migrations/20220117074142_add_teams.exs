defmodule LiveSup.Repo.Migrations.AddTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: false, null: false
      add :slug, :string, default: false, null: false
      add :avatar_url, :string
      add :settings, :map, default: "{}"
      add :labels, {:array, :string}, default: []
      add :project_id, references(:projects, type: :uuid)

      timestamps()
    end

    create index(
             :teams,
             [:slug],
             unique: true
           )

    create table(:team_members, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :team_id, references(:teams, type: :uuid), null: false
      add :user_id, references(:users, type: :uuid), null: false
      add :manager, :boolean, default: false, null: false

      timestamps()
    end

    create(index(:team_members, [:team_id, :user_id], unique: true))
  end
end
