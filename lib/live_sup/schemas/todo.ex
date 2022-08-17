defmodule LiveSup.Schemas.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{Project, User, Todo}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "todos" do
    field :title, :string
    field :description, :string
    field :color_code, :string

    belongs_to :project, Project
    belongs_to :author, User

    timestamps()
  end

  @required_fields [
    :title
  ]

  @optional_fields [
    :project_id,
    :description,
    # This field should be required
    :author_id,
    :color_code
  ]

  def changeset(%Todo{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
