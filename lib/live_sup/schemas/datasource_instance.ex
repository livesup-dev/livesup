defmodule LiveSup.Schemas.DatasourceInstance do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{WidgetInstance, Datasource, DatasourceInstance, Project}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "datasource_instances" do
    field :name, :string
    field :enabled, :boolean
    field :settings, :map

    has_many :widgets_instances, WidgetInstance

    # If the project isn't present then
    # it's a public datasource instance
    belongs_to :project, Project
    belongs_to :datasource, Datasource

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
end
