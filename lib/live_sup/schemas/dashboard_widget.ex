defmodule LiveSup.Schemas.DashboardWidget do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Dashboard, WidgetInstance}

  @already_exists "ALREADY_EXISTS"

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "dashboards_widgets" do
    field :order, :integer, default: 999

    belongs_to :dashboard, Dashboard
    belongs_to :widget_instance, WidgetInstance

    timestamps()
  end

  @required_fields [
    :dashboard_id,
    :widget_instance_id
  ]

  @optional_fields [:order]

  @doc false
  def changeset(dashboard_widget_listing, attrs) do
    dashboard_widget_listing
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:dashboard_id)
    |> foreign_key_constraint(:widget_instance_id)
    |> unique_constraint([:dashboard, :widget_instance_],
      name: :dashboard_widget_unique,
      message: @already_exists
    )
  end
end
