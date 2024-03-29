defmodule LiveSup.Schemas.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{User, DatasourceInstance}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "links" do
    field(:settings, :map, default: %{})
    # Redundant field, but it's needed for filtering
    field(:datasource_slug, :string)

    belongs_to(:user, User)
    belongs_to(:datasource_instance, DatasourceInstance)

    timestamps()
  end

  @required_fields [
    :user_id,
    :datasource_instance_id,
    :datasource_slug
  ]

  @optional_fields [
    :settings
  ]

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
