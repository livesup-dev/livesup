defmodule LiveSup.Schemas.MergeStat.Repository do
  use Ecto.Schema

  @doc """
  git commit history of a repo
  https://docs.mergestat.com/mergestat/querying/schema/tables/repos
  """

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "repos" do
    field(:repo, :string)
    field(:ref, :string)
    field(:created_at, :utc_datetime)
    field(:settings, :map)
    field(:provider, :string)
    field(:tags, {:array, :map})
    field(:repo_import_id, :binary_id)

    has_many(:commits, LiveSup.Schemas.MergeStat.GitCommit, foreign_key: :repo_id)
  end
end
