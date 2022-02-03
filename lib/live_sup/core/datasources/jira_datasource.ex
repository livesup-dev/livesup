defmodule LiveSup.Core.Datasources.JiraDatasource do
  alias LiveSup.Core.Datasources.HttpDatasource
  alias LiveSup.Helpers.DateHelper

  # The Jira REST API
  # https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/
  #
  # JIRA Agile REST API Reference
  # https://docs.atlassian.com/jira-software/REST/7.0.4/
  #
  @api_path "/rest/api/3"
  @agile_api_path "/rest/agile/1.0"

  @status ["In Progress", "Complete", "Open", "Blocked", "In Review", "Validating"]
  @open_status ["In Progress", "Open", "Blocked", "In Review", "Scoping"]
  @blocked_status ["Blocked"]
  @close_status ["Complete"]

  def status, do: @status
  def open_status, do: @open_status
  def blocked_status, do: @blocked_status
  def close_status, do: @close_status

  def search_user(email, token: token, domain: domain) do
    case HttpDatasource.get(
           url: build_url("/user/search?query=#{email}", domain: domain, base_path: @api_path),
           headers: headers(token)
         ) do
      {:ok, response} -> get_first_user(response)
      {:error, error} -> {:error, error}
    end
  end

  def search_tickets(query, token: token, domain: domain) do
    query = """
        {
          "expand": [
              "changelog"
          ],
          "jql": "#{query}",
          "maxResults": 15,
          "fieldsByKeys": false,
          "fields": [
              "summary",
              "status",
              "assignee",
              "creator",
              "created",
              "components"
          ],
          "startAt": 0
      }
    """

    case HttpDatasource.post(
           url: build_url("/search", domain: domain, base_path: @api_path),
           body: query,
           headers: headers(token)
         ) do
      {:ok, response} -> parse_issues(response)
      {:error, error} -> {:error, error}
    end
  end

  def get_current_sprint(board_id, token: token, domain: domain) do
    url =
      build_url("/board/#{board_id}/sprint?state=active",
        domain: domain,
        base_path: @agile_api_path
      )

    case HttpDatasource.get(
           url: url,
           headers: headers(token)
         ) do
      {:ok, response} -> parse_sprint(response)
      {:error, error} -> {:error, error}
    end
  end

  def get_current_sprint_issues(board_id, token: token, domain: domain) do
    {:ok, current_sprint} = board_id |> get_current_sprint(token: token)

    case HttpDatasource.get(
           url:
             build_url(
               "/sprint/#{current_sprint[:id]}/issue?fields=resolution,status,assignee,creator,description,summary,created",
               domain: domain,
               base_path: @agile_api_path
             ),
           headers: headers(token)
         ) do
      {:ok, response} -> parse_issues(response)
      {:error, error} -> {:error, error}
    end
  end

  def get_board_issues(board_id, token: token, domain: domain) do
    case HttpDatasource.get(
           url:
             build_url(
               "/board/#{board_id}/issue?fields=resolution,status,assignee,creator,description,summary",
               domain: domain,
               base_path: @agile_api_path
             ),
           headers: headers(token)
         ) do
      {:ok, response} -> parse_issues(response)
      {:error, error} -> {:error, error}
    end
  end

  defp parse_sprint(jira_sprints) do
    jira_sprint = jira_sprints["values"] |> Enum.at(0)
    end_date = DateHelper.parse_date(jira_sprint["endDate"])

    {:ok,
     %{
       id: jira_sprint["id"],
       state: jira_sprint["state"],
       name: jira_sprint["name"],
       startDate: jira_sprint["startDate"],
       endDate: jira_sprint["endDate"],
       goal: jira_sprint["goal"],
       days_left: NaiveDateTime.local_now() |> DateHelper.diff_in_days(end_date)
     }}
  end

  defp parse_issues(%{"issues" => issues}) do
    issues
    |> Enum.map(fn issue ->
      {author, created_at} = issue |> find_author()
      assignee = issue |> find_assignee()
      components = issue |> parse_components()

      %{
        key: issue["key"],
        summary: issue["fields"]["summary"],
        status: issue["fields"]["status"]["name"],
        status_order: status_order(issue["fields"]["status"]["name"]),
        author: author,
        assignee: assignee,
        created_at: created_at,
        components: components,
        created_at_ago: created_at |> DateHelper.from_now()
      }
    end)
  end

  # We need to find a way to make these jira status
  # dynamically manage
  defp status_order("In Progress"), do: 1
  defp status_order("In Review"), do: 2
  defp status_order("IN REVIEW"), do: 2
  defp status_order("Open"), do: 3
  defp status_order("Validating"), do: 4
  defp status_order("Blocked"), do: 5
  defp status_order("Scoping"), do: 6
  defp status_order("Complete"), do: 7
  defp status_order("Done"), do: 8
  defp status_order("Staging"), do: 9
  defp status_order("Discovery"), do: 10
  defp status_order("Product Review"), do: 11

  def find_author(%{"fields" => %{"creator" => creator, "created" => created}}) do
    author = %{
      full_name: creator["displayName"],
      avatar: creator["avatarUrls"]["48x48"],
      email: creator["emailAddress"]
    }

    created_at = created |> DateHelper.parse_date()

    {author, created_at}
  end

  def find_author(%{"changelog" => %{"histories" => histories}}) do
    last = List.last(histories)

    author = %{
      full_name: last["author"]["displayName"],
      avatar: last["author"]["avatarUrls"]["48x48"]
    }

    created_at = last["created"] |> DateHelper.parse_date()

    {author, created_at}
  end

  def find_assignee(%{"fields" => %{"assignee" => nil}}), do: nil

  def find_assignee(%{"fields" => %{"assignee" => assignee}}) do
    %{
      full_name: assignee["displayName"],
      avatar: assignee["avatarUrls"]["48x48"],
      email: assignee["emailAddress"]
    }
  end

  def parse_components(%{"fields" => %{"components" => nil}}), do: nil

  def parse_components(%{"fields" => %{"components" => components}}) do
    components
    |> Enum.map(fn component ->
      %{
        name: component["name"]
      }
    end)
  end

  def parse_components(%{"fields" => _}), do: nil

  defp get_first_user([]), do: nil

  defp get_first_user(users) do
    users
    |> Enum.at(0)
  end

  def headers(token) do
    [
      {"Authorization", "Basic #{token}"},
      {"Content-Type", "application/json"}
    ]
  end

  def build_url(path, domain: domain, base_path: base_path) do
    "#{domain}#{base_path}#{path}"
  end
end
