defmodule LiveSup.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :citext, null: false
      add :first_name, :string
      add :last_name, :string
      add :avatar_url, :string
      add :provider, :string
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :location, :map, default: "{}"
      add :settings, :map, default: "{}"
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    create table(:projects, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :labels, {:array, :string}, default: []
      add :internal, :boolean, default: false, null: false
      add :settings, :map, default: "{}"
      add :parent_id, references(:projects, on_delete: :nothing, type: :uuid)
      add :slug, :citext

      timestamps()
    end

    create index(:projects, [:parent_id])
    create unique_index(:projects, [:slug, :internal], where: "internal = true")

    create table(:groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :internal, :boolean, default: false, null: false
      add :slug, :citext

      timestamps()
    end

    create unique_index(:groups, [:slug, :internal], where: "internal = true")

    create table(:projects_groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :project_id, references(:projects, on_delete: :delete_all, type: :uuid), null: false
      add :group_id, references(:groups, on_delete: :delete_all, type: :uuid), null: false
      add :default, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:projects_groups, [:project_id, :group_id])

    create table(:users_groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :group_id, references(:groups, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:users_groups, [:user_id, :group_id])

    create table(:dashboards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :default, :boolean, null: false, default: false
      add :labels, {:array, :string}, default: []
      add :settings, :map, default: "{}"
      add :project_id, references(:projects, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:dashboards, [:project_id, :name])

    create table(:datasources, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string, null: false
      add :description, :string
      add :feature_image_url, :string
      add :slug, :string, null: false
      add :settings, :map, default: "{}", null: false
      add :category, :string
      add :enabled, :boolean, default: false
      add :labels, {:array, :string}, default: []

      timestamps()
    end

    create(unique_index(:datasources, :slug))

    create table(:datasource_instances, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string, null: false
      add :settings, :map, default: "{}", null: false
      add :enabled, :boolean, default: false
      add :datasource_id, references(:datasources, on_delete: :nothing, type: :uuid)
      add :project_id, references(:projects, on_delete: :nothing, type: :uuid), null: true

      timestamps()
    end

    create table(:widgets, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string, null: false
      add :description, :string
      add :ui_handler, :string, null: false
      add :worker_handler, :string, null: false
      add :slug, :string, null: false
      add :feature_image_url, :string
      add :settings, :map, default: "{}", null: false
      add :category, :string
      add :enabled, :boolean, default: false
      add :labels, {:array, :string}, default: []
      add :weight, :float, null: false, default: 0
      add :global, :boolean, null: false, default: false
      add :datasource_id, references(:datasources, on_delete: :nilify_all, type: :uuid)

      timestamps()
    end

    create(unique_index(:widgets, :slug))

    create table(:widget_instances, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :name, :string, null: false
      add :settings, :map, default: "{}", null: false
      add :enabled, :boolean, default: false

      add :datasource_instance_id,
          references(:datasource_instances, on_delete: :nilify_all, type: :uuid),
          null: false

      add :widget_id,
          references(:widgets, on_delete: :nilify_all, type: :uuid),
          null: false

      timestamps()
    end

    create table(:dashboards_widgets, primary_key: false) do
      add :id, :uuid, primary_key: true

      add(
        :widget_instance_id,
        references(:widget_instances, on_delete: :delete_all, type: :uuid),
        null: false
      )

      add(
        :dashboard_id,
        references(:dashboards, on_delete: :delete_all, type: :uuid),
        null: false
      )

      timestamps()
    end

    create index(:dashboards_widgets, [:widget_instance_id])
    create index(:dashboards_widgets, [:dashboard_id])

    create unique_index(:dashboards_widgets, [:widget_instance_id, :dashboard_id],
             name: :dashboard_widget_listing_unique
           )
  end
end
