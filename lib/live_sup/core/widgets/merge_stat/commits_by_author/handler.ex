defmodule LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource

  def get_data(%{"repo" => repo, "limit" => limit}) do
    repo
    |> MergeStatDatasource.commits_by_author(limit: limit)
  end
end
