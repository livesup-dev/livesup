defmodule LiveSup.Core.Widgets.MergeStat.ReviewsByAuthor.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource

  def get_data(%{"repo" => repo, "limit" => limit}) do
    repo
    |> MergeStatDatasource.reviews_by_author(limit: limit)
  end
end
