defmodule LiveSup.Test.Core.Datasources.MergeStatDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Core.Datasources.MergeStatDatasource

  describe "managing merge stat datasource" do
    @describetag :datasource
    @describetag :merge_stat_datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "Get list committers", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/", fn conn ->
        Plug.Conn.resp(conn, 200, response())
      end)

      {:ok, data} =
        MergeStatDatasource.run_query(
          %{
            "repo" => "livesup",
            "query" =>
              "SELECT author_name, count(*) as count FROM commits GROUP BY author_name ORDER BY count DESC "
          },
          url: endpoint_url(bypass.port)
        )

      assert [
               %{"author_name" => "Jonatan Kłosko", "count" => 341},
               %{"author_name" => "jonatanklosko", "count" => 123},
               %{"author_name" => "José Valim", "count" => 91},
               %{"author_name" => "josevalim", "count" => 10},
               %{"author_name" => "Wojtek Mach", "count" => 10}
             ] = data
    end

    test "Failing to run query", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/", fn conn ->
        Plug.Conn.resp(conn, 500, error_response())
      end)

      data =
        MergeStatDatasource.run_query(
          %{
            "repo" => "livesup",
            "query" => "invalid query"
          },
          url: endpoint_url(bypass.port)
        )

      assert {:error, "500: could not execute query: near \"asdf\": syntax error"} = data
    end

    def response() do
      """
      {
        "runningTime": 2667410254,
        "rows": [
            {
                "author_name": "Jonatan Kłosko",
                "count": 341
            },
            {
                "author_name": "jonatanklosko",
                "count": 123
            },
            {
                "author_name": "José Valim",
                "count": 91
            },
            {
                "author_name": "josevalim",
                "count": 10
            },
            {
                "author_name": "Wojtek Mach",
                "count": 10
            }
        ],
        "columnNames": [
            "author_name",
            "count"
        ],
        "columnTypes": [
            "TEXT",
            ""
        ]
      }
      """
    end

    def error_response(), do: "could not execute query: near \"asdf\": syntax error"

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
