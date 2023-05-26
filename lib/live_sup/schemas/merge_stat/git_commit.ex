defmodule LiveSup.Schemas.MergeStat.GitCommit do
  use Ecto.Schema

  @doc """
  git commit history of a repo
  https://docs.mergestat.com/mergestat/querying/schema/tables/git_commits
  """
  schema "git_commits" do
    field(:hash, :string)
    field(:author_name, :string)
    field(:author_email, :string)
    field(:author_when, :string)
    field(:committer_name, :string)
    field(:committer_email, :string)
    field(:committer_when, :string)
    field(:parents, :integer)

    belongs_to(:repo, LiveSup.Schemas.MergeStat.Repository, foreign_key: :repo_id)
  end
end
