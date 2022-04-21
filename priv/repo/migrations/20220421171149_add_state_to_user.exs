defmodule LiveSup.Repo.Migrations.AddStateToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :state, :string
    end
  end
end
