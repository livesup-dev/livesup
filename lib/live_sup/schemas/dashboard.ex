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
    :settings
  ]

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required([:name])
  end
end
