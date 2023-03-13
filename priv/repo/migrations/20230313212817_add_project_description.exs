defmodule LiveSup.Repo.Migrations.AddProjectDescription do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :description, :string
      add :color, :string
    end
  end
end
