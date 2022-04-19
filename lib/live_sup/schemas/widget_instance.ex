defmodule LiveSup.Schemas.WidgetInstance do
  use Ecto.Schema
  import Ecto.Changeset

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

  defp find_values(keys) do
    keys
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.merge(acc, %{key => find_value(value)})
    end)
  end

  defp find_value(%{"type" => "string", "value" => value, "source" => "local"}), do: value

  defp find_value(%{"type" => "int", "value" => value, "source" => "local"})
       when is_binary(value) do
    case Integer.parse(value) do
      {int_val, ""} -> int_val
      :error -> raise "#{value} is not a valid int"
    end
  end

  defp find_value(%{"type" => "array", "value" => value, "source" => "local"})
       when is_binary(value) do
    value
    |> String.split(",")
  end

  defp find_value(%{"type" => "int", "value" => value}), do: value
  defp find_value(%{"source" => "env", "value" => env_var}), do: System.get_env(env_var)
  defp find_value(%{"source" => "local", "value" => value}), do: value
  defp find_value(value), do: value

  defp get_values_from_settings(settings, keys) do
    settings
    |> Map.take(keys)
  end

  def custom_title(%__MODULE__{} = instance) do
    instance
    |> get_setting("title")
  end
end
