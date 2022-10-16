# We need to use different name for the model
# because it is conflicting with https://hexdocs.pm/elixir/1.13/Task.html
defmodule LiveSup.Schemas.TodoTask do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{User, Todo, TodoTask, Comment}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "tasks" do
    field(:description, :string)
    field(:notes, :string)
    field(:completed, :boolean, default: false)
    field(:due_on, LiveSup.Schemas.CustomTypes.Datetime)

    belongs_to(:parent, TodoTask)
    belongs_to(:todo, Todo)
    belongs_to(:assigned_to, User)
    belongs_to(:created_by, User)
    has_many(:comments, Comment, foreign_key: :task_id)

    timestamps()
  end

  @required_fields [
    :description,
    :todo_id
  ]

  @optional_fields [
    :notes,
    :completed,
    :due_on,
    :parent_id,
    :assigned_to_id,
    :created_by_id
  ]

  def create_changeset(%TodoTask{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(%TodoTask{} = model, attrs) do
    model
    |> cast(attrs, [:description] ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
