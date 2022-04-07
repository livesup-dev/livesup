defmodule LiveSup.Schemas.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Project, DashboardWidget}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "dashboards" do
    field :name, :string
    field :labels, {:array, :string}
    field :settings, :map
    field :default, :boolean
    field :avatar_url, :string

    belongs_to :project, Project
    has_many :dashboards_widgets, DashboardWidget
    has_many :widgets, through: [:dashboards_widgets, :widgets_instances]

    timestamps()
  end

  @required_fields [
    :name,
    :project_id
  ]

  @optional_fields [
    :default,
    :labels,
    :settings,
    :id,
    :avatar_url
  ]

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required([:name])
  end

  def default_avatar_url(%__MODULE__{avatar_url: avatar_url}) do
    avatar_url || default_avatar_url()
  end

  def default_avatar_url() do
    "/images/default-dashboard-avatar.png"
  end
end
