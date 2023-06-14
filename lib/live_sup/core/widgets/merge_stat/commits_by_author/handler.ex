defmodule LiveSup.Core.Widgets.MergeStat.CommitsByAuthor.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource
  alias LiveSup.Core.Links
  alias LiveSup.Schemas.User

  def get_data(%{"repo" => repo, "limit" => limit}, %{
        widget_instance: %{datasource_instance: datasource_instance}
      }) do
    case repo
         |> MergeStatDatasource.commits_by_author(limit: limit) do
      {:ok, data} -> {:ok, data |> parse_data(datasource_instance)}
      {:error, error} -> {:error, error}
    end
  end

  defp parse_data(data, datasource_instance) do
    data
    |> Enum.map(fn %{"author_name" => author_name} = item ->
      user = author_name |> find_user(datasource_instance)

      item
      |> Map.merge(%{"user" => user})
    end)
  end

  def find_user(username, datasource_instance) do
    case username |> Links.get_from_github_username(datasource_instance) do
      nil -> %User{first_name: username, last_name: ""}
      link -> link.user
    end
  end
end
