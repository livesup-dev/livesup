defmodule LiveSup.Repo.Migrations.AddAvatarToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :avatar_url, :string
    end
  end
end
