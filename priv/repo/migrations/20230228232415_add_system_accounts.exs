defmodule LiveSup.Repo.Migrations.AddSystemAccounts do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:system, :boolean, default: false)
      add(:system_identifier, :string)
    end

    create(unique_index(:users, [:system_identifier], name: :users_system_identifier_index))
  end
end
