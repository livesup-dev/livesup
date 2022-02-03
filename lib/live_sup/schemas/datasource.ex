defmodule LiveSup.Schemas.Datasource do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Widget, Datasource}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "datasources" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :feature_image_url, :string
    field :category, :string
    field :enabled, :boolean
    field :settings, :map
    field :labels, {:array, :string}, default: []

    has_many :widgets, Widget

    timestamps()
  end

  @required_fields [
    :name,
    :slug,
    :settings,
    :labels
  ]

  @optional_fields [
    :description,
    :feature_image_url,
    :category,
    :enabled
  ]

  def changeset(%Datasource{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
