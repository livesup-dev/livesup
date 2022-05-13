defmodule LiveSup.Schemas.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{User, Datasource}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "links" do
    field :settings, :map, default: %{}

    belongs_to :user, User
    belongs_to :datasource, Datasource

    timestamps()
  end

  @required_fields []

  @optional_fields [
    :user_id,
    :datasource_id,
    :settings
  ]

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def jira_slug(), do: "jira-datasource"
end
