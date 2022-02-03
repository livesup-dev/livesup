defmodule LiveSup.Core.Datasources.GithubDatasource do
  use Timex

  @feature_flag_name "github_data_source"
  @endpoint "https://api.github.com/"

  alias LiveSup.Helpers.{StringHelper, DateHelper}

  def get_pull_requests(owner, repository, opts \\ []) do
    token = Keyword.fetch!(opts, :token)
    endpoint = Keyword.get(opts, :endpoint, @endpoint)
    filter = Keyword.get(opts, :filter, %{})

    with {200, pulls, _response} <-
           Tentacat.Pulls.filter(
             client(endpoint, token),
             owner,
             repository,
             Map.merge(default_filter(), filter)
           ) do
      {:ok, pulls |> process_pulls()}
    else
      {status, %{"message" => error_message}, _} -> {:error, "#{status}: #{error_message}"}
    end
  end

  defp process_pulls(pulls) do
    pulls
    |> Enum.map(fn pull_request ->
      pull_request
      |> build_pull_map()
    end)
  end

  defp build_pull_map(%{"state" => "closed", "merged_at" => nil}), do: nil

  defp build_pull_map(nil), do: nil

  defp build_pull_map(pull_request) do
    created_at_details = pull_request |> build_created_at_date()
    merged_at_details = pull_request |> build_merged_at_date()

    %{
      title: pull_request["title"],
      short_title: StringHelper.truncate(pull_request["title"], max_length: 43),
      number: pull_request["number"],
      html_url: pull_request["html_url"],
      repo: %{
        name: pull_request["head"]["repo"]["name"],
        html_url: pull_request["head"]["repo"]["html_url"]
      },
      user: %{
        id: pull_request["user"]["id"],
        avatar_url: pull_request["user"]["avatar_url"],
        login: pull_request["user"]["login"],
        html_url: pull_request["user"]["html_url"]
      }
    }
    |> Map.merge(created_at_details)
    |> Map.merge(merged_at_details)
  end

  defp build_created_at_date(pull_request) do
    created_at = pull_request["created_at"] |> DateHelper.parse_date()
    created_at_ago = created_at |> DateHelper.from_now()

    %{
      created_at: created_at,
      created_at_ago: created_at_ago
    }
  end

  defp build_merged_at_date(%{"merged_at" => nil}) do
    %{
      merged_at: "",
      merged_at_ago: ""
    }
  end

  defp build_merged_at_date(%{"merged_at" => merged_at}) do
    merged_at = merged_at |> DateHelper.parse_date()
    merged_at_ago = merged_at |> DateHelper.from_now()

    %{
      merged_at: merged_at,
      merged_at_ago: merged_at_ago
    }
  end

  defp client(endpoint, token) do
    Tentacat.Client.new(
      %{
        access_token: token
      },
      endpoint
    )
  end

  defp default_filter() do
    %{
      "per_page" => 10,
      "page" => 1,
      "pagination" => "none"
    }
  end
end
