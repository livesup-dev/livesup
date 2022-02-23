defmodule LiveSup.Schemas.Metric do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{MetricValue, Metric}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "metrics" do
    field :name, :string
    field :slug, :string
    field :target, :float
    field :unit, :string
    field :settings, :map, default: %{}
    field :labels, {:array, :string}, default: []

    has_many :metric_values, MetricValue

    timestamps()
  end

  @required_fields [
    :name,
    :slug,
    :target,
    :unit
  ]

  @optional_fields [
    :settings,
    :labels
  ]

  def changeset(%Metric{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(%Metric{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
