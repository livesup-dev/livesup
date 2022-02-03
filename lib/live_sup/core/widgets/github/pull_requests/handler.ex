defmodule LiveSup.Core.Widgets.Github.PullRequests.Handler do
  alias LiveSup.Core.Datasources.GithubDatasource

  def get_data(%{"owner" => _, "repository" => _, "state" => state, "token" => _} = args) do
    with {:ok, pulls} <- args |> get_pulls() do
      pulls |> process_pulls(state)
    else
      {:error, error} -> {:error, error}
    end
  end

  def process_pulls(pulls, state) do
    data =
      pulls
      |> Enum.filter(&(!is_nil(&1)))

    {:ok, data}
  end

  def get_pulls(%{
        "owner" => owner,
        "repository" => repository,
        "state" => state,
        "token" => token
      }) do
    GithubDatasource.get_pull_requests(
      owner,
      repository,
      token: token,
      filter: state |> build_filter()
    )
  end

  defp build_filter("open") do
    %{state: "open", sort: "created", dir: "asc"}
  end

  defp build_filter("closed") do
    %{state: "open", sort: "pdated", dir: "desc"}
  end
end
