defmodule LiveSup.Schemas.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Group, ProjectGroup, Slugs.GroupSlug, UserGroup}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "groups" do
    field :internal, :boolean, default: false
    field :name, :string
    field :slug, GroupSlug.Type

    has_many :projects_groups, ProjectGroup
    has_many :projects, through: [:projects_groups, :project]

    has_many :users_groups, UserGroup
    has_many :users, through: [:users_groups, :user]

    timestamps()
  end

  @doc false
  def changeset(%Group{} = group, attrs) do
    group
    |> cast(attrs, [:name, :internal, :slug])
    |> validate_required([:name])
    |> GroupSlug.maybe_generate_slug()
  end
end
