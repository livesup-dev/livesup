# We need to use different name for the model
# because it is conflicting with https://hexdocs.pm/elixir/1.13/Task.html
defmodule LiveSup.Schemas.TodoTask do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{User, Todo, TodoTask, Comment, DatasourceInstance}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "tasks" do
    field(:title, :string)
    field(:description, :string)
    field(:notes, :string)
    field(:priority, :string)
    field(:tags, {:array, :string}, default: [])
    field(:completed, :boolean, default: false)
    field(:completed_at, LiveSup.Schemas.CustomTypes.Datetime)
    field(:external_identifier, :string)
    field(:external_metadata, :map, default: %{})
    field(:datasource_slug, :string)
    field(:due_on, LiveSup.Schemas.CustomTypes.Datetime)

    belongs_to(:parent, TodoTask)
    belongs_to(:todo, Todo)
    belongs_to(:assigned_to, User)
    belongs_to(:created_by, User)
    belongs_to(:datasource_instance, DatasourceInstance)
    has_many(:comments, Comment, foreign_key: :task_id)

    timestamps()
  end

  @priorities [
    "high",
    "medium",
    "low"
  ]

  @required_fields [
    :title,
    :todo_id
  ]

  @optional_fields [
    :notes,
    :completed,
    :completed_at,
    :due_on,
    :parent_id,
    :assigned_to_id,
    :created_by_id,
    :priority,
    :tags,
    :external_metadata,
    :external_identifier,
    :datasource_instance_id,
    :description,
    :updated_at,
    :inserted_at,
    :datasource_slug
  ]

  def create_changeset(%TodoTask{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:priority, @priorities)
  end

  def update_changeset(%TodoTask{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def priorities do
    @priorities
  end

  def local?(%TodoTask{datasource_instance_id: nil}), do: true
  def local?(%TodoTask{datasource_instance_id: _}), do: false

  def high_priority, do: "high"
  def medium_priority, do: "medium"
  def low_priority, do: "low"
end
