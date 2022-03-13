defmodule LiveSup.Schemas.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{MetricValue, Metric}
  alias LiveSup.Schemas.Slugs.MetricSlug

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "metrics" do
    field :name, :string
    field :slug, MetricSlug.Type
    field :target, :float
    field :unit, :string
    field :settings, :map, default: %{}
    field :labels, {:array, :string}, default: []

    has_many :metric_values, MetricValue

    timestamps()
  end

  @required_fields [
    :name,
    :target,
    :unit
  ]

  @optional_fields [
    :slug,
    :settings,
    :labels
  ]

  def changeset(%Metric{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> MetricSlug.maybe_generate_slug()
  end
end
