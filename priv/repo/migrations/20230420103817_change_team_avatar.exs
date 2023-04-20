defmodule LiveSup.Repo.Migrations.ChangeTeamAvatar do
  use Ecto.Migration

  def change do
    rename table(:teams), :avatar_url, to: :avatar
  end
end
