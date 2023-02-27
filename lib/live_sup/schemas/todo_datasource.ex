defmodule LiveSup.Schemas.TodoDatasource do
  use Ecto.Schema
  import Ecto.Changeset
  import LiveSup.Schemas.Helpers.SettingsHandler

  alias LiveSup.Schemas.{Todo, DatasourceInstance}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "todo_datasources" do
    field(:settings, :map, default: %{})
    field(:last_run_at, LiveSup.Schemas.CustomTypes.Datetime)

    belongs_to(:todo, Todo)
    belongs_to(:datasource_instance, DatasourceInstance)

    timestamps()
  end

  @required_fields [
    :todo_id,
    :datasource_instance_id,
    :settings
  ]

  @optional_fields [:id, :last_run_at]

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def get_setting(%__MODULE__{} = model, key) do
    model
    |> build_settings()
    |> Map.get(key)
    |> find_value()
  end

  def get_settings(%__MODULE__{} = model, keys) do
    model
    |> build_settings()
    |> get_values_from_settings(keys)
    |> find_values()
  end

  defp build_settings(%{
         settings: model_settings,
         datasource_instance: %{
           settings: datasource_instance_settings,
           datasource: %{settings: datasource_settings}
         }
       }) do
    datasource_settings
    |> Map.merge(datasource_instance_settings)
    |> Map.merge(model_settings)
  end
end
