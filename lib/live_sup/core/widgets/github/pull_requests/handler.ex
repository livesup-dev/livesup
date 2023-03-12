defmodule LiveSup.Core.Widgets.Github.PullRequests.Handler do
  alias LiveSup.Core.Datasources.GithubDatasource

  def get_data(%{"owner" => _, "repository" => _, "token" => _} = args) do
    case args |> get_pulls() do
      {:ok, pulls} ->
        pulls |> process_pulls()

      {:error, error} ->
        {:error, error}
    end
  end

  def process_pulls(pulls) do
    data =
      pulls
      |> Enum.filter(&(!is_nil(&1)))

    {:ok, data}
  end

  def get_pulls(
        %{
          "owner" => owner,
          "repository" => repository,
          "token" => token
        } = args
      ) do
    GithubDatasource.get_pull_requests(
      owner,
      repository,
      token: token,
      filter: build_filter(args)
    )
  end

  defp build_filter(%{"state" => "open", "limit" => limit}) do
    %{state: "open", sort: "created", direction: "asc", per_page: limit}
  end

  defp build_filter(%{"state" => "closed", "limit" => limit}) do
    %{state: "closed", sort: "created", direction: "desc", per_page: limit}
  end

  defp build_filter(%{
         "state" => state,
         "sort" => sort,
         "limit" => limit,
         "direction" => direction,
         "updated" => updated
       }) do
    %{state: state, sort: sort, direction: direction, per_page: limit, updated: updated}
  end

  defp build_filter(%{
         "sort" => sort,
         "limit" => limit,
         "direction" => direction,
         "updated" => updated
       }) do
    %{sort: sort, direction: direction, per_page: limit, updated: updated}
  end
end
