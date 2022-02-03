defmodule LiveSup.Schemas.TeamMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{TeamMember, User, Team}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "team_members" do
    field :manager, :boolean, default: false

    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

  @required_fields [
    :user_id,
    :team_id
  ]

  @optional_fields [
    :manager
  ]

  def changeset(%TeamMember{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
