defmodule LiveSup.Schemas.Favorite do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "favorites" do
    field(:entity_id, Ecto.UUID)
    field(:entity_type, :string)

    field(:entity, :map, virtual: true)

    belongs_to(:user, User)

    timestamps()
  end

  @required_fields [
    :entity_id,
    :entity_type,
    :user_id
  ]

  @optional_fields []

  @entity_types ["user", "project", "dashboard"]

  @doc false
  def changeset(favorite, attrs) do
    favorite
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_inclusion(:entity_type, @entity_types)
    |> validate_required(@required_fields)
  end

  def project_type(), do: "project"
  def todo_type(), do: "user"
  def dashboard_type(), do: "dashboard"
end
