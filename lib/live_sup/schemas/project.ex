defmodule LiveSup.Schemas.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{ProjectGroup, Dashboard, DatasourceInstance, Todo}
  alias LiveSup.Schemas.Slugs.ProjectSlug

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "projects" do
    field :internal, :boolean, default: false
    field :labels, {:array, :string}
    field :name, :string
    field :color, :string
    field :description, :string
    field :settings, :map
    field :parent_id, :binary_id
    field :slug, ProjectSlug.Type
    field :avatar_url, :string
    field(:todos_count, :integer, default: 0, virtual: true)
    field(:dashboards_count, :integer, default: 0, virtual: true)

    has_many :projects_groups, ProjectGroup
    has_many :groups, through: [:projects_groups, :group]
    has_many :dashboards, Dashboard
    has_many :todos, Todo
    has_many :datasource_instances, DatasourceInstance

    timestamps()
  end

  @required_fields [
    :name
  ]

  @optional_fields [
    :internal,
    :settings,
    :labels,
    :slug,
    :avatar_url,
    :id,
    :description,
    :color
  ]

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> ProjectSlug.maybe_generate_slug()
  end

  def default_avatar_url(%__MODULE__{avatar_url: avatar_url}) do
    avatar_url || default_avatar_url()
  end

  def default_avatar_url() do
    "/images/default-project-avatar.png"
  end
end
