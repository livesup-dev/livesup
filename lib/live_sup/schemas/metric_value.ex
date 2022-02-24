defmodule LiveSup.Schemas.MetricValue do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{MetricValue, Metric}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "metric_values" do
    field :value, :float, default: 0.0
    field :value_date, :naive_datetime
    field :settings, :map, default: %{}

    belongs_to :metric, Metric

    timestamps()
  end

  @required_fields [
    :metric_id,
    :value,
    :value_date
  ]

  @optional_fields [
    :settings
  ]

  def changeset(%MetricValue{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(%MetricValue{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
