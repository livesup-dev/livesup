defmodule LiveSup.Schemas.WidgetInstance do
  use Ecto.Schema
  import Ecto.Changeset
  import LiveSup.Schemas.Helpers.SettingsHandler

  alias LiveSup.Schemas.{
    DashboardWidget,
    Widget,
    WidgetInstance,
    DatasourceInstance
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "widget_instances" do
    field :name, :string
    field :enabled, :boolean
    field :settings, :map

    belongs_to :datasource_instance, DatasourceInstance
    belongs_to :widget, Widget

    has_many :dashboards_widgets, DashboardWidget
    has_many :dashboards, through: [:dashboards_widgets, :dashboards]
    has_many :widgets, through: [:dashboards_widgets, :widgets]

    timestamps()
  end

  @required_fields [
    :name,
    :settings,
    :datasource_instance_id
  ]

  @optional_fields [
    :enabled,
    :widget_id,
    :id
  ]

  # def enabled?(%WidgetInstance{} = model) do
  #   # TODO: We need to check the datasource, if it is enabled,
  #   # then we use the widget flag, otherwise it should be disabled.
  # end

  def changeset(%WidgetInstance{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:datasource_instance_id)
    |> foreign_key_constraint(:widget_id)
  end

  def with_schedule?(%WidgetInstance{} = widget) do
    widget.settings["schedule"] != "none"
  end

  def get_setting(%__MODULE__{} = instance, key) do
    instance
    |> build_settings()
    |> Map.get(key)
    |> find_value()
  end

  def get_settings(%__MODULE__{} = instance, keys) do
    instance
    |> build_settings()
    |> get_values_from_settings(keys)
    |> find_values()
  end

  # TOOD: Improve this function to manage those cases
  # where the relationships are not loaded
  defp build_settings(instance) do
    instance.datasource_instance.datasource.settings
    |> Map.merge(instance.datasource_instance.settings)
    |> Map.merge(instance.widget.settings)
    |> Map.merge(instance.settings)
  end

  def custom_title(%__MODULE__{} = instance) do
    instance
    |> get_setting("title")
  end
end
