defmodule LiveSup.Repo.Migrations.AddDashboardsAvatars do
  use Ecto.Migration

  def change do
    alter table(:dashboards) do
      add :avatar_url, :string
    end
  end
end
