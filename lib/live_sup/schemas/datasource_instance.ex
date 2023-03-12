defmodule LiveSup.Schemas.DatasourceInstance do
  use Ecto.Schema
  import Ecto.Changeset
  import LiveSup.Schemas.Helpers.SettingsHandler

  alias LiveSup.Schemas.{WidgetInstance, Datasource, DatasourceInstance, Project, TodoDatasource}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "datasource_instances" do
    field(:name, :string)
    field(:enabled, :boolean)
    field(:settings, :map)

    has_many(:widgets_instances, WidgetInstance)
    has_many(:todo_datasources, TodoDatasource)

    # If the project isn't present then
    # it's a public datasource instance
    belongs_to(:project, Project)
    belongs_to(:datasource, Datasource)

    timestamps()
  end

  @required_fields [
    :name,
    :settings,
    :datasource_id
  ]

  @optional_fields [
    :project_id,
    :enabled
  ]

  def changeset(%DatasourceInstance{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
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

  defp build_settings(instance) do
    instance.datasource.settings
    |> Map.merge(instance.settings)
  end
end
