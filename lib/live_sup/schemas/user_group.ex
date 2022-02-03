defmodule LiveSup.Schemas.UserGroup do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveSup.Schemas.{User, Group}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "users_groups" do
    belongs_to :group, Group
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:group_id, :user_id])
  end
end
