defmodule LiveSup.Schemas.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Project, User, Todo, TodoTask, TodoDatasource}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "todos" do
    field(:title, :string)
    field(:description, :string)
    field(:color_code, :string)
    field(:position, :integer)
    field(:archived, :boolean)
    field(:archived_at, :naive_datetime)
    field(:open_tasks_count, :integer, default: 0, virtual: true)
    field(:completed_tasks_count, :integer, default: 0, virtual: true)

    belongs_to(:project, Project)
    belongs_to(:created_by, User)

    has_many(:tasks, TodoTask)
    has_many(:datasources, TodoDatasource)

    timestamps()
  end

  @required_fields [
    :title
  ]

  @optional_fields [
    :id,
    :project_id,
    :description,
    # This field should be required
    :created_by_id,
    :color_code,
    :position,
    :archived,
    :archived_at
  ]

  def changeset(%Todo{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
