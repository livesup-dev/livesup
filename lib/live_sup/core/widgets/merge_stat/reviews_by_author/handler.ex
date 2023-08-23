defmodule LiveSup.Core.Widgets.MergeStat.ReviewsByAuthor.Handler do
  alias LiveSup.Core.Datasources.MergeStatDatasource
  alias LiveSup.Core.Links
  alias LiveSup.Schemas.User

  def get_data(%{"repo" => repo, "limit" => limit}) do
    case repo
         |> MergeStatDatasource.reviews_by_author(limit: limit) do
      {:ok, data} -> {:ok, data |> parse_data()}
      {:error, error} -> {:error, error}
    end
  end

  defp parse_data(data) do
    data
    |> Enum.map(fn %{"author_login" => author_login} = item ->
      user = author_login |> find_user()

      item
      |> Map.merge(%{"user" => user})
    end)
  end

  def find_user(username) do
    case username |> Links.get_from_github_username() do
      nil -> %User{first_name: username, last_name: nil}
      link -> link.user
    end
  end
end
