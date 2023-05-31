defmodule LiveSup.Core.Widgets.MergeStat.TimeToMerge.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource

  def get_data(%{"repos" => repos}) do
    {:ok, data} =
      repos
      |> MergeStatDatasource.time_to_merge([])

    {:ok,
     data
     |> parse_repos()}
  end

  defp parse_repos(stats) do
    stats
    |> Enum.map(fn stat ->
      stat
      |> Map.merge(%{"label" => label(stat["repo"])})
    end)
  end

  defp label(repo) do
    repo
    |> String.split("/")
    |> List.last()
  end
end
