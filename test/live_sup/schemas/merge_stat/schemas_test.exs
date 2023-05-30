defmodule LiveSup.Tests.Schemas.MergeStats.QueriesTest do
  use ExUnit.Case
  use LiveSup.DataCase

  alias LiveSup.Schemas.MergeStat.{Repository, GitCommit, GitBlame}

  describe "merges stat schemas" do
    @describetag :merge_stat_schema

    @tag :merge_stat_commits
    test "commits" do
      assert LiveSup.Repo.to_sql(:all, GitCommit) ==
               {
                 "SELECT g0.\"id\", g0.\"hash\", g0.\"author_name\", g0.\"author_email\", g0.\"author_when\", g0.\"committer_name\", g0.\"committer_email\", g0.\"committer_when\", g0.\"parents\", g0.\"repo_id\" FROM \"git_commits\" AS g0",
                 []
               }
    end

    @tag :merge_stat_repos
    test "repos" do
      assert LiveSup.Repo.to_sql(:all, Repository) ==
               {
                 "SELECT r0.\"id\", r0.\"repo\", r0.\"ref\", r0.\"created_at\", r0.\"settings\", r0.\"provider\", r0.\"tags\", r0.\"repo_import_id\" FROM \"repos\" AS r0",
                 []
               }

      repo_with_commits =
        from(p in Repository,
          join: c in assoc(p, :commits),
          where: c.hash == "1234"
        )

      assert LiveSup.Repo.to_sql(:all, repo_with_commits) ==
               {
                 "SELECT r0.\"id\", r0.\"repo\", r0.\"ref\", r0.\"created_at\", r0.\"settings\", r0.\"provider\", r0.\"tags\", r0.\"repo_import_id\" FROM \"repos\" AS r0 INNER JOIN \"git_commits\" AS g1 ON g1.\"repo_id\" = r0.\"id\" WHERE (g1.\"hash\" = '1234')",
                 []
               }
    end

    @tag :merge_stat_git_blame
    test "git blame" do
      assert LiveSup.Repo.to_sql(:all, GitBlame) ==
               {
                 "SELECT g0.\"repo_id\", g0.\"author_email\", g0.\"author_name\", g0.\"author_when\", g0.\"commit_hash\", g0.\"line_no\", g0.\"line\", g0.\"path\", g0.\"_mergestat_synced_at\" FROM \"git_blame\" AS g0",
                 []
               }
    end
  end
end
