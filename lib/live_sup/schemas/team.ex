defmodule LiveSup.Schemas.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{TeamMember, Project}
  alias LiveSup.Schemas.Slugs.TeamSlug

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "teams" do
    field(:name, :string)
    field(:slug, TeamSlug.Type)
    field(:avatar, :string)
    field(:description, :string)
    field(:settings, :map, default: %{})
    field(:labels, {:array, :string}, default: [])

    has_many(:team_members, TeamMember)
    has_many(:members, through: [:team_members, :user])
    belongs_to(:project, Project)

    timestamps()
  end

  @required_fields [
    :name
  ]

  @optional_fields [
    :id,
    :avatar,
    :settings,
    :labels,
    :slug,
    :project_id,
    :description
  ]

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> TeamSlug.maybe_generate_slug()
  end

  def default_avatar(%__MODULE__{avatar: avatar}) do
    avatar || "/images/default-team-avatar.png"
  end
end
