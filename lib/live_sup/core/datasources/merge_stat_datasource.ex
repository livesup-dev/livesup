defmodule LiveSup.Core.Datasources.MergeStatDatasource do
  @moduledoc """
    It provides an interface to the MergeStat API
  """
  alias LiveSup.Core.Datasources.HttpDatasource
  alias LiveSup.Core.MemoryStore

  @receive_timeout 15_000

  def commits_by_author(repo, params) do
    limit = params |> Keyword.get(:limit, 10)

    sql = """
    SELECT
        git_commits.author_name,
        git_commits.author_email,
        count(git_commits)
    FROM git_commits
    INNER JOIN repos ON git_commits.repo_id = repos.id
    WHERE
        git_commits.committer_when IS NOT NULL
        AND git_commits.parents < 2
        AND repos.repo = '#{repo}'
    GROUP BY 1,2
    ORDER BY 3 DESC
    limit #{limit}
    """

    # This query takes some times to load, so we need
    # a higger timeout
    {:ok, result} =
      sql
      |> run_query(Keyword.merge(params, receive_timeout: 40_000))

    {:ok,
     result
     |> parse_list()}
  end

  def changes_per_month(repo, params) do
    sql = """
    SELECT
        EXTRACT(Month FROM git_commits.author_when) AS month,
        SUM(git_commit_stats.additions - git_commit_stats.deletions) AS net_changes,
        SUM(git_commit_stats.additions) as additions,
        SUM(git_commit_stats.deletions) as deletions
    FROM git_commits
    INNER JOIN repos ON git_commits.repo_id = repos.id
    -- join on both hash and repo as the hash can be the same in different repos when forking
    INNER JOIN git_commit_stats ON git_commits.hash = git_commit_stats.commit_hash AND git_commits.repo_id = git_commit_stats.repo_id
    WHERE
        git_commits.committer_when IS NOT NULL
        AND git_commits.parents < 2 -- exclude merge commits
        AND EXTRACT(YEAR from now()) = EXTRACT(YEAR FROM git_commits.author_when)
        AND repos.repo = '#{repo}'
    GROUP BY 1
    ORDER BY 1
    """

    # This query takes some times to load, so we need
    # a higger timeout
    {:ok, result} =
      sql
      |> run_query(Keyword.merge(params, receive_timeout: 40_000))

    {:ok,
     result
     |> parse_list()}
  end

  def total_net_changes_by_author(repo, params) do
    limit = params |> Keyword.get(:limit, 10)

    sql = """
    SELECT
        git_commits.author_name,
        git_commits.author_email,
        SUM(git_commit_stats.additions - git_commit_stats.deletions) AS net_changes,
        SUM(git_commit_stats.additions) as additions,
        SUM(git_commit_stats.deletions) as deletions
    FROM git_commits
    INNER JOIN repos ON git_commits.repo_id = repos.id
    -- join on both hash and repo as the hash can be the same in different repos when forking
    INNER JOIN git_commit_stats ON git_commits.hash = git_commit_stats.commit_hash AND git_commits.repo_id = git_commit_stats.repo_id
    WHERE
        git_commits.committer_when IS NOT NULL
        AND git_commits.parents < 2 -- exclude merge commits
        AND repos.repo = '#{repo}'
    GROUP BY 1,2
    ORDER BY 3 DESC
    limit #{limit}
    """

    {:ok, result} =
      sql
      |> run_query(Keyword.merge(params, receive_timeout: 40_000))

    {:ok,
     result
     |> parse_list()}
  end

  def total_pull_requests_per_year(repo, params) do
    sql = """
    SELECT
        EXTRACT(Year FROM github_pull_requests.created_at) AS year,
        COUNT(*) AS total_pull_requests
    FROM github_pull_requests
    INNER JOIN repos ON github_pull_requests.repo_id = repos.id
    WHERE
        github_pull_requests.created_at IS NOT NULL
        AND EXTRACT(YEAR from now()) = EXTRACT(YEAR FROM github_pull_requests.created_at)
        AND repos.repo = '#{repo}'
    GROUP BY 1
    ORDER BY 1 DESC, 2 DESC
    """

    {:ok, result} =
      sql
      |> run_query(params)

    result
    |> parse_list()
  end

  def total_pull_requests_per_month(repo, params) do
    sql = """
    SELECT
        EXTRACT(Month FROM github_pull_requests.created_at) AS month,
        COUNT(*) AS total_pull_requests
    FROM github_pull_requests
    INNER JOIN repos ON github_pull_requests.repo_id = repos.id
    WHERE
        github_pull_requests.created_at IS NOT NULL
        AND EXTRACT(YEAR from now()) = EXTRACT(YEAR FROM github_pull_requests.created_at)
        AND repos.repo = '#{repo}'
    GROUP BY 1
    ORDER BY 1 DESC, 2 DESC
    """

    {:ok, result} =
      sql
      |> run_query(params)

    {:ok,
     result
     |> parse_list()}
  end

  def first_commit(repo, params) do
    sql = """
    SELECT git_commits.*
    FROM git_commits
    INNER JOIN repos ON git_commits.repo_id = repos.id
    WHERE repos.repo = '#{repo}'
    ORDER BY committer_when ASC
    LIMIT 1
    """

    {:ok, result} =
      sql
      |> run_query(params)

    {:ok,
     result
     |> parse_single_element()}
  end

  def last_commit(repo, params) do
    sql = """
    SELECT git_commits.*
    FROM git_commits
    INNER JOIN repos ON git_commits.repo_id = repos.id
    WHERE repos.repo = '#{repo}'
    ORDER BY committer_when DESC
    LIMIT 1
    """

    {:ok, result} =
      sql
      |> run_query(params)

    {:ok,
     result
     |> parse_single_element()}
  end

  def total_commits(repo, params \\ []) do
    sql = """
        SELECT
            COUNT(*) AS count
        FROM git_commits
        INNER JOIN repos ON git_commits.repo_id = repos.id
        WHERE
            git_commits.committer_when IS NOT NULL
            AND git_commits.parents < 2
            AND repos.repo = '#{repo}'
        ORDER BY 1 DESC
    """

    # TODO: We are not handling errors here
    {:ok, result} =
      sql
      |> run_query(params)

    {:ok, result |> parse_single_total() |> String.to_integer()}
  end

  def parse_single_total(%{"data" => %{"execSQL" => %{"rows" => [[count]]}}}), do: count

  def parse_list(%{"data" => %{"execSQL" => %{"rows" => rows, "columns" => columns}}}),
    do: convert_arrays_to_maps(columns, rows)

  def parse_single_element(%{"data" => %{"execSQL" => %{"rows" => rows, "columns" => columns}}}) do
    convert_arrays_to_maps(columns, rows)
    |> List.first()
  end

  def run_query(sql, params \\ []) do
    url = params |> Keyword.get(:url)
    token = params |> Keyword.get(:token, fetch_token(params))
    receive_timeout = params |> Keyword.get(:receive_timeout, @receive_timeout)

    body = %{
      operationName: "executeSQL",
      variables: %{
        sql: "#{sql}",
        disableReadOnly: true,
        trackHistory: false
      },
      query: """
      query executeSQL($sql: String!, $disableReadOnly: Boolean, $trackHistory: Boolean) {
        execSQL(
          input: {query: $sql, disableReadOnly: $disableReadOnly, trackHistory: $trackHistory}
        ) {
          rowCount
          columns
          rows
          queryRunningTimeMs
          __typename
        }
      }
      """
    }

    case HttpDatasource.post(
           url: build_url("/api/graphql", url),
           body: body,
           headers: headers(token),
           receive_timeout: receive_timeout
         ) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> {:error, error}
    end
  end

  def auth(params \\ []) do
    # TODO: Deal with these configs missing
    url = params |> Keyword.get(:url, LiveSup.Config.merge_stat_url())
    user = params |> Keyword.get(:user, LiveSup.Config.merge_stat_user())
    password = params |> Keyword.get(:password, LiveSup.Config.merge_stat_password())

    body = %{
      user: user,
      password: password
    }

    case HttpDatasource.headers(
           url: build_url("/api/admin-auth", url),
           body: body,
           headers: auth_headers()
         ) do
      {:ok, headers} -> {:ok, extract_token(headers)}
      {:error, error} -> raise error
    end
  end

  defp extract_token(headers) do
    case headers
         |> List.keyfind("set-cookie", 0) do
      {"set-cookie", value} ->
        value
        |> String.split("; ")
        |> Enum.at(0)
        |> String.replace("jwt=", "")

      _ ->
        ""
    end
  end

  defp fetch_token(params) do
    # Temporary until we have a way to grab the token
    # from the auth call. When that happens we have to use auth()

    # TODO: We need to deal with token expiration
    case MemoryStore.get("mergestat:token", 300) do
      {:ok, token} ->
        token

      {:error, _} ->
        {:ok, token} = auth(params)
        MemoryStore.put("mergestat:token", token)
        token
    end
  end

  defp headers(token) do
    [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"}
    ]
  end

  defp auth_headers() do
    [
      {"Content-Type", "application/json"}
    ]
  end

  def build_url(path, url) do
    "#{url}#{path}"
  end

  def convert_arrays_to_maps(keys_list, values_list) do
    keys = Enum.map(keys_list, fn %{"name" => name} -> name end)
    Enum.map(values_list, &Enum.into(Enum.zip(keys, &1), %{}))
  end
end
