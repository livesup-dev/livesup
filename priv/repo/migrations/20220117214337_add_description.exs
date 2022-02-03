defmodule LiveSup.Repo.Migrations.AddDescription do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :description, :string
    end
  end
end
