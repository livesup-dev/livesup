defmodule LiveSup.Core.Datasources.GithubDatasource do
  @moduledoc """
    It provides an interface to the Github API using their
    own implementation Tentacat
  """

  use Timex

  @endpoint "https://api.github.com/"

  alias LiveSup.Helpers.{StringHelper, DateHelper}

  def get_pull_requests(owner, repository, opts \\ []) do
    token = Keyword.fetch!(opts, :token)
    endpoint = Keyword.get(opts, :endpoint, @endpoint)
    filter = Keyword.get(opts, :filter, %{})

    call_result =
      Tentacat.Pulls.filter(
        client(endpoint, token),
        owner,
        repository,
        Map.merge(default_filter(), filter)
      )

    case call_result do
      {200, pulls, _response} ->
        {:ok, pulls |> process_pulls()}

      {status, %{"message" => error_message}, _} ->
        {:error, "#{status}: #{error_message}"}
    end
  end

  def search_pull_requests(owner, repository, opts) do
    token = Keyword.fetch!(opts, :token)
    endpoint = Keyword.get(opts, :endpoint, @endpoint)
    filter = Keyword.get(opts, :filter, nil)

    query =
      if filter do
        "is:pr repo:#{owner}/#{repository} #{filter}"
      else
        "is:pr repo:#{owner}/#{repository}"
      end

    call_result =
      Tentacat.Search.issues(
        client(endpoint, token),
        %{q: query, sort: "created"}
      )

    case call_result do
      {200, pulls, _response} ->
        {:ok, pulls |> process_pulls()}

      {status, %{"message" => error_message}, _} ->
        {:error, "#{status}: #{error_message}"}
    end
  end

  defp process_pulls(%{"items" => pulls}) do
    pulls
    |> Enum.map(fn pull_request ->
      pull_request
      |> build_pull_map()
    end)
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
    # TODO: Refactor this PLEASE
    created_at_details = pull_request |> build_created_at_date()
    merged_at_details = pull_request |> build_merged_at_date()
    updated_at_details = pull_request |> build_updated_at_date()
    closed_at_details = pull_request |> build_closed_at_date()

    %{
      id: Integer.to_string(pull_request["id"]),
      body: pull_request["body"],
      title: pull_request["title"],
      state: pull_request["state"],
      short_title: StringHelper.truncate(pull_request["title"], max_length: 55),
      number: pull_request["number"],
      html_url: pull_request["html_url"],
      repo: %{
        name: pull_request_name(pull_request),
        html_url: pull_request_url(pull_request)
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
    |> Map.merge(updated_at_details)
    |> Map.merge(closed_at_details)
  end

  defp build_updated_at_date(%{"updated_at" => nil}) do
    %{
      updated_at: "",
      updated_at_ago: ""
    }
  end

  defp build_updated_at_date(%{"updated_at" => updated_at}) do
    updated_at = updated_at |> DateHelper.parse_date()
    updated_at_ago = updated_at |> DateHelper.from_now()

    %{
      updated_at: updated_at,
      updated_at_ago: updated_at_ago
    }
  end

  defp build_merged_at_date(%{"closed_at" => nil}) do
    %{
      closed: false,
      closed_at: "",
      closed_ago: ""
    }
  end

  defp build_closed_at_date(%{"closed_at" => closed_at}) do
    closed_at = closed_at |> DateHelper.parse_date()
    closed_at_ago = closed_at |> DateHelper.from_now()

    %{
      closed: true,
      closed_at: closed_at,
      closed_at_ago: closed_at_ago
    }
  end

  defp build_created_at_date(%{"created_at" => created_at}) do
    created_at = created_at |> DateHelper.parse_date()
    created_at_ago = created_at |> DateHelper.from_now()

    %{
      created_at: created_at,
      created_at_ago: created_at_ago
    }
  end

  defp build_merged_at_date(%{"merged_at" => nil}) do
    %{
      merged: false,
      merged_at: "",
      merged_at_ago: ""
    }
  end

  defp build_merged_at_date(%{"merged_at" => merged_at}) do
    merged_at = merged_at |> DateHelper.parse_date()
    merged_at_ago = merged_at |> DateHelper.from_now()

    %{
      merged: true,
      merged_at: merged_at,
      merged_at_ago: merged_at_ago
    }
  end

  def pull_request_name(%{"head" => %{"repo" => %{"pull_name" => pull_name}}}), do: pull_name

  def pull_request_name(%{"pull_request" => %{"url" => url}}) do
    {_owner, repo} = parse_github_url(url)
    repo
  end

  def pull_request_url(%{"head" => %{"repo" => %{"pull_url" => pull_url}}}), do: pull_url
  def pull_request_url(%{"pull_request" => %{"html_url" => html_url}}), do: html_url

  def parse_github_url(url) do
    [_, _, _, "repos", owner, repo, "pulls" | _rest] = String.split(url, "/")
    {owner, repo}
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
      per_page: 20,
      page: 1,
      pagination: "none"
    }
  end
end
