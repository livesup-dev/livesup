defmodule LiveSup.Repo.Migrations.AddMetricsTable do
  use Ecto.Migration

  def change do
    create table(:metrics, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, default: false, null: false
      add :slug, :string, default: false, null: false
      add :target, :float, null: false
      add :unit, :string, null: false
      add :settings, :map, default: "{}"
      add :labels, {:array, :string}, default: []

      timestamps()
    end

    create index(
             :metrics,
             [:slug],
             unique: true
           )

    create table(:metric_values, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :metric_id, references(:metrics, type: :uuid), null: false
      add :value, :float, null: false
      add :value_date, :naive_datetime, null: false
      add :settings, :map, default: "{}"

      timestamps()
    end

    create(index(:metric_values, [:metric_id, :value_date], unique: true))
  end
end
