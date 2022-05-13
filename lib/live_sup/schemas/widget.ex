defmodule LiveSup.Schemas.Widget do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Widget, Datasource, WidgetInstance}
  alias LiveSup.Schemas.Slugs.WidgetSlug

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "widgets" do
    field :name, :string
    field :description, :string
    field :ui_handler, :string
    field :worker_handler, :string
    field :slug, WidgetSlug.Type
    field :feature_image_url, :string
    field :category, :string
    field :enabled, :boolean
    field :settings, :map
    field :ui_settings, :map, default: %{}
    field :weight, :float
    field :global, :boolean, default: true
    field :labels, {:array, :string}, default: []

    belongs_to :datasource, Datasource
    has_many :widget_instances, WidgetInstance

    timestamps()
  end

  @required_fields [
    :name,
    :ui_handler,
    :worker_handler,
    :labels,
    :slug,
    :global
  ]

  @optional_fields [
    :settings,
    :description,
    :feature_image_url,
    :category,
    :enabled,
    :weight,
    :ui_settings,
    :datasource_id
  ]

  def enabled?(%Widget{} = _model) do
    # TODO: We need to check the datasource, if it is enabled,
    # then we use the widget flag, otherwise it should be disabled.
  end

  def changeset(%Widget{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> assoc_constraint(:datasource)
    |> validate_required(@required_fields)
  end

  def ui_settings(settings) do
    Map.merge(%{"size" => 1}, settings)
  end

  def default_feature_image_url(%__MODULE__{feature_image_url: feature_image_url}) do
    feature_image_url || "/images/default-widget.png"
  end

  def settings(%__MODULE__{} = widget) do
    Map.merge(widget.datasource.settings, widget.settings)
  end
end
