defmodule LiveSup.Schemas.MergeStat.GitBlame do
  use Ecto.Schema

  @doc """
  git blame of all lines in all files of a repo
  https://docs.mergestat.com/mergestat/querying/schema/tables/git_blame
  """

  @primary_key false
  schema "git_blame" do
    belongs_to(:repo, LiveSup.Schemas.MergeStat.Repository, type: :binary_id, primary_key: true)
    field(:author_email, :string)
    field(:author_name, :string)
    field(:author_when, :utc_datetime)
    field(:commit_hash, :string)
    field(:line_no, :integer)
    field(:line, :string)
    field(:path, :string)
    field(:_mergestat_synced_at, :utc_datetime)
  end
end
