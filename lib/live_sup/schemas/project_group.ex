defmodule LiveSup.Schemas.ProjectGroup do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.Project
  alias LiveSup.Schemas.Group

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "projects_groups" do
    field :default, :boolean, default: false

    belongs_to :project, Project
    belongs_to :group, Group

    timestamps()
  end

  @required_fields [
    :project_id,
    :group_id
  ]

  @optional_fields [
    :default
  ]

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
