defmodule LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource
  import Logger

  @default_limit 5
  @query "SELECT author_name, count(*) as count FROM commits GROUP BY author_name ORDER BY count DESC"

  def get_data(%{"repo" => repo, "limit" => limit}) do
    debug("Handler: #{repo}")

    query =
      @query
      |> build_query(limit)

    %{"repo" => repo, "query" => query}
    |> MergeStatDatasource.run_query()
  end

  defp build_query(query, nil), do: "#{query} limit #{@default_limit}"
  defp build_query(query, limit), do: "#{query} limit #{limit}"
end
