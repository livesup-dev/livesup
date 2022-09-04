defmodule LiveSup.Schemas.Comment do
  @moduledoc """
  Comments schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Comment, User, TodoTask}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "comments" do
    field :body, :string

    belongs_to :task, TodoTask
    belongs_to :created_by, User

    timestamps()
  end

  @required_fields [
    :body,
    :created_by_id,
    :task_id
  ]

  @optional_fields []

  def changeset(%Comment{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
