defmodule LiveSup.Test.Core.Datasources.MergeStatDatasourceTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Datasources.MergeStatDatasource

  describe "managing merge stat datasource" do
    @describetag :datasource
    @describetag :merge_stat_datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :mergestat_run_query
    test "run query", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      {:ok, data} =
        MergeStatDatasource.run_query(
          "SELECT author_name, count(*) as count FROM commits GROUP BY author_name ORDER BY count DESC",
          url: endpoint_url(bypass.port)
        )

      assert %{
               "data" => %{
                 "execSQL" => %{
                   "__typename" => "ExecSQLResult",
                   "columns" => [
                     %{"format" => "text", "name" => "author_name"},
                     %{"format" => "text", "name" => "count"}
                   ],
                   "queryRunningTimeMs" => 4,
                   "rowCount" => 5,
                   "rows" => [
                     ["mustela", "300"],
                     ["Emiliano Jankowski", "96"],
                     ["Memo", "78"],
                     ["dependabot[bot]", "8"],
                     ["Pierre-Alexandre Meyer", "1"]
                   ]
                 }
               }
             } = data
    end

    @tag :mergestat_first_commit
    test "first_commit/2", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, first_commit_response())
      end)

      {:ok, data} =
        MergeStatDatasource.first_commit(
          "https://github.com/livesup-dev/livesup",
          url: endpoint_url(bypass.port)
        )

      assert %{
               "_mergestat_synced_at" => "2023-05-26T22:29:04.896Z",
               "author_email" => "ejankowski@gmail.com",
               "author_name" => "mustela",
               "author_when" => "2022-02-03T09:15:16.000Z",
               "committer_email" => "ejankowski@gmail.com",
               "committer_name" => "mustela",
               "committer_when" => "2022-02-03T09:15:16.000Z",
               "hash" => "ef452c4b8db986c5d33cab0c252d7b6c42390eda",
               "message" => "Init",
               "parents" => 0,
               "repo_id" => "294e7377-622c-44f5-b640-5793dc346b6b"
             } = data
    end

    @tag :mergestat_total_commits
    test "total_commits/2", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, total_commit_response())
      end)

      {:ok, data} =
        MergeStatDatasource.total_commits(
          "https://github.com/livesup-dev/livesup",
          url: endpoint_url(bypass.port)
        )

      assert 363 = data
    end

    @tag :mergestat_commits_by_authors
    test "commits_by_authors/2", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, commits_by_authors_response())
      end)

      {:ok, data} =
        MergeStatDatasource.commits_by_author(
          "https://github.com/livesup-dev/livesup",
          url: endpoint_url(bypass.port)
        )

      assert [
               %{
                 "author_email" => "ejankowski@gmail.com",
                 "author_name" => "mustela",
                 "count" => "296"
               },
               %{
                 "author_email" => "guillermo@dinkuminteractive.com",
                 "author_name" => "Memo",
                 "count" => "47"
               },
               %{
                 "author_email" => "ejankowski@gmail.com",
                 "author_name" => "Emiliano Jankowski",
                 "count" => "11"
               },
               %{
                 "author_email" => "49699333+dependabot[bot]@users.noreply.github.com",
                 "author_name" => "dependabot[bot]",
                 "count" => "8"
               },
               %{
                 "author_email" => "pierre@mouraf.org",
                 "author_name" => "Pierre-Alexandre Meyer",
                 "count" => "1"
               }
             ] = data
    end

    @tag :mergestat_time_to_merge
    test "time_to_merge/2", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, time_to_merge_response())
      end)

      {:ok, data} =
        MergeStatDatasource.time_to_merge(
          "https://github.com/livesup/billing-it,https://github.com/livesup/embs,https://github.com/livesup/billing-api,https://github.com/livesup/kb-deploy,https://github.com/livesup/api",
          url: endpoint_url(bypass.port)
        )

      assert [
               %{
                 "avg_days_to_merge" => "6.24",
                 "repo" => "https://github.com/livesup/billing-it"
               },
               %{"avg_days_to_merge" => "3.61", "repo" => "https://github.com/livesup/embs"},
               %{"avg_days_to_merge" => "3.41", "repo" => "https://github.com/livesup/kb-deploy"},
               %{"avg_days_to_merge" => "2.21", "repo" => "https://github.com/livesup/api"},
               %{
                 "avg_days_to_merge" => "1.68",
                 "repo" => "https://github.com/livesup/billing-api"
               }
             ] = data
    end

    @tag :mergestat_reviews_by_author
    test "reviews_by_author/2", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, reviews_by_author_response())
      end)

      {:ok, data} =
        MergeStatDatasource.reviews_by_author(
          "https://github.com/livesup-dev/livesup",
          url: endpoint_url(bypass.port)
        )

      assert [
               %{
                 "author_login" => "dammhammed",
                 "total_pull_requests_reviewed" => "52"
               },
               %{
                 "author_login" => "shl311289",
                 "total_pull_requests_reviewed" => "31"
               },
               %{
                 "author_login" => "RptorGndalf",
                 "total_pull_requests_reviewed" => "28"
               },
               %{
                 "author_login" => "jnscheffr",
                 "total_pull_requests_reviewed" => "23"
               },
               %{
                 "author_login" => "JAORMX",
                 "total_pull_requests_reviewed" => "4"
               }
             ] = data
    end

    def time_to_merge_response do
      """
      {
        "data":{
           "execSQL":{
              "rowCount":5,
              "columns":[
                 {
                    "name":"repo",
                    "format":"text"
                 },
                 {
                    "name":"avg_days_to_merge",
                    "format":"text"
                 }
              ],
              "rows":[
                 [
                    "https://github.com/livesup/billing-it",
                    "6.24"
                 ],
                 [
                    "https://github.com/livesup/embs",
                    "3.61"
                 ],
                 [
                    "https://github.com/livesup/kb-deploy",
                    "3.41"
                 ],
                 [
                    "https://github.com/livesup/api",
                    "2.21"
                 ],
                 [
                    "https://github.com/livesup/billing-api",
                    "1.68"
                 ]
              ],
              "queryRunningTimeMs":35,
              "__typename":"ExecSQLResult"
           }
        }
      }
      """
    end

    def reviews_by_author_response do
      """
      {
        "data":{
           "execSQL":{
              "rowCount":5,
              "columns":[
                 {
                    "name":"author_login",
                    "format":"text"
                 },
                 {
                    "name":"total_pull_requests_reviewed",
                    "format":"text"
                 }
              ],
              "rows":[
                 [
                    "dammhammed",
                    "52"
                 ],
                 [
                    "shl311289",
                    "31"
                 ],
                 [
                    "RptorGndalf",
                    "28"
                 ],
                 [
                    "jnscheffr",
                    "23"
                 ],
                 [
                    "JAORMX",
                    "4"
                 ]
              ],
              "queryRunningTimeMs":18,
              "__typename":"ExecSQLResult"
           }
        }
      }
      """
    end

    def first_commit_response do
      """
      {
        "data": {
            "execSQL": {
                "rowCount": 1,
                "columns": [
                    {
                        "name": "repo_id",
                        "format": "text"
                    },
                    {
                        "name": "hash",
                        "format": "text"
                    },
                    {
                        "name": "message",
                        "format": "text"
                    },
                    {
                        "name": "author_name",
                        "format": "text"
                    },
                    {
                        "name": "author_email",
                        "format": "text"
                    },
                    {
                        "name": "author_when",
                        "format": "text"
                    },
                    {
                        "name": "committer_name",
                        "format": "text"
                    },
                    {
                        "name": "committer_email",
                        "format": "text"
                    },
                    {
                        "name": "committer_when",
                        "format": "text"
                    },
                    {
                        "name": "parents",
                        "format": "text"
                    },
                    {
                        "name": "_mergestat_synced_at",
                        "format": "text"
                    }
                ],
                "rows": [
                    [
                        "294e7377-622c-44f5-b640-5793dc346b6b",
                        "ef452c4b8db986c5d33cab0c252d7b6c42390eda",
                        "Init",
                        "mustela",
                        "ejankowski@gmail.com",
                        "2022-02-03T09:15:16.000Z",
                        "mustela",
                        "ejankowski@gmail.com",
                        "2022-02-03T09:15:16.000Z",
                        0,
                        "2023-05-26T22:29:04.896Z"
                    ]
                ],
                "queryRunningTimeMs": 6,
                "__typename": "ExecSQLResult"
            }
        }
      }
      """
    end

    def commits_by_authors_response do
      """
      {
        "data": {
            "execSQL": {
                "rowCount": 5,
                "columns": [
                    {
                        "name": "author_name",
                        "format": "text"
                    },
                    {
                        "name": "author_email",
                        "format": "text"
                    },
                    {
                        "name": "count",
                        "format": "text"
                    }
                ],
                "rows": [
                    [
                        "mustela",
                        "ejankowski@gmail.com",
                        "296"
                    ],
                    [
                        "Memo",
                        "guillermo@dinkuminteractive.com",
                        "47"
                    ],
                    [
                        "Emiliano Jankowski",
                        "ejankowski@gmail.com",
                        "11"
                    ],
                    [
                        "dependabot[bot]",
                        "49699333+dependabot[bot]@users.noreply.github.com",
                        "8"
                    ],
                    [
                        "Pierre-Alexandre Meyer",
                        "pierre@mouraf.org",
                        "1"
                    ]
                ],
                "queryRunningTimeMs": 5,
                "__typename": "ExecSQLResult"
            }
        }
      }
      """
    end

    def total_commit_response do
      """
      {
        "data": {
            "execSQL": {
                "rowCount": 1,
                "columns": [
                    {
                        "name": "count",
                        "format": "text"
                    }
                ],
                "rows": [
                    [
                        "363"
                    ]
                ],
                "queryRunningTimeMs": 3,
                "__typename": "ExecSQLResult"
            }
        }
      }
      """
    end

    def response() do
      """
      {
        "data": {
            "execSQL": {
                "rowCount": 5,
                "columns": [
                    {
                        "name": "author_name",
                        "format": "text"
                    },
                    {
                        "name": "count",
                        "format": "text"
                    }
                ],
                "rows": [
                    [
                        "mustela",
                        "300"
                    ],
                    [
                        "Emiliano Jankowski",
                        "96"
                    ],
                    [
                        "Memo",
                        "78"
                    ],
                    [
                        "dependabot[bot]",
                        "8"
                    ],
                    [
                        "Pierre-Alexandre Meyer",
                        "1"
                    ]
                ],
                "queryRunningTimeMs": 4,
                "__typename": "ExecSQLResult"
            }
        }
      }
      """
    end

    def error_response(), do: "could not execute query: near \"asdf\": syntax error"

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
