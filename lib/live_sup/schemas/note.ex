defmodule LiveSup.Schemas.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  schema "notes" do
    field :title, :string
    field :content, :string
    field :slug, :string

    timestamps()
  end

  @required_fields [
    :content,
    :slug
  ]

  @optional_fields [
    :title
  ]

  def changeset(%__MODULE__{} = model, attrs) do
    model
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
