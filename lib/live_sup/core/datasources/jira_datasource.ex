defmodule LiveSup.Core.Datasources.JiraDatasource do
  @moduledoc """
    It provides an interface to the Jira API. Under the hood
    it uses the HttpDataSource to perform the requests.
  """
  alias LiveSup.Core.Datasources.HttpDatasource
  alias LiveSup.Helpers.DateHelper

  # The Jira REST API
  # https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/
  #
  # JIRA Agile REST API Reference
  # https://docs.atlassian.com/jira-software/REST/7.0.4/
  #
  # Basic authentication
  # https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/#supply-basic-auth-headers
  #
  @api_path "/rest/api/3"
  @agile_api_path "/rest/agile/1.0"
  def search_user(email_or_name, token: token, domain: domain) do
    query =
      %{
        query: email_or_name
      }
      |> URI.encode_query()

    case HttpDatasource.get(
           url: build_url("/user/search?#{query}", domain: domain, base_path: @api_path),
           headers: headers(token)
         ) do
      {:ok, response} -> get_first_user(response)
      {:error, error} -> {:error, error}
    end
  end

  def search_tickets(query, token: token, domain: domain) do
    query = %{
      expand: [
        "changelog"
      ],
      jql: query,
      maxResults: 15,
      fieldsByKeys: false,
      fields: [
        "summary",
        "status",
        "assignee",
        "creator",
        "created",
        "components"
      ],
      startAt: 0
    }

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
    # TODO: This need to be refactored
    case get_current_sprint(board_id, token: token, domain: domain) do
      {:ok, %{id: current_sprint_id}} ->
        case HttpDatasource.get(
               url:
                 build_url(
                   "/sprint/#{current_sprint_id}/issue?fields=resolution,status,assignee,creator,description,summary,created",
                   domain: domain,
                   base_path: @agile_api_path
                 ),
               headers: headers(token)
             ) do
          {:ok, response} -> parse_issues(response)
          {:error, error} -> {:error, error}
        end

      {:error, error} ->
        {:error, error}
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

  def get_project_status(project, token: token, domain: domain) do
    case HttpDatasource.get(
           url:
             build_url(
               "/project/#{project}/statuses",
               domain: domain,
               base_path: @api_path
             ),
           headers: headers(token)
         ) do
      {:ok, response} -> response |> build_statuses()
      {:error, error} -> {:error, error}
    end
  end

  defp build_statuses(issues_types) do
    data =
      issues_types
      |> Enum.map(fn issue_type ->
        issue_type |> parse_statuses()
      end)
      |> Enum.uniq_by(fn status -> status[:id] end)
      |> List.flatten()

    {:ok, data}
  end

  defp parse_statuses(%{"statuses" => statuses}) do
    statuses
    |> Enum.map(fn status_attr ->
      %{
        id: status_attr["id"],
        name: status_attr["name"]
      }
    end)
  end

  defp parse_sprint(%{"values" => []}) do
    {:error, :no_active_sprint}
  end

  defp parse_sprint(%{"values" => values}) do
    jira_sprint = values |> Enum.at(0)
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
    data =
      issues
      |> Enum.map(fn issue ->
        {author, created_at} = issue |> find_author()
        assignee = issue |> find_assignee()
        components = issue |> parse_components()

        %{
          key: issue["key"],
          summary: issue["fields"]["summary"],
          status: issue["fields"]["status"]["name"],
          author: author,
          assignee: assignee,
          created_at: created_at,
          components: components,
          created_at_ago: created_at |> DateHelper.from_now()
        }
      end)

    {:ok, data}
  end

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

  defp get_first_user([]), do: {:error, :not_found}

  defp get_first_user(users) do
    user =
      users
      |> Enum.at(0)
      |> parse_user()

    {:ok, user}
  end

  defp parse_user(jira_user) do
    %{
      account_id: jira_user["accountId"],
      active: jira_user["active"],
      avatar_url: jira_user["avatarUrls"]["48x48"],
      time_zone: jira_user["timeZone"],
      local: jira_user["locale"],
      name: jira_user["displayName"],
      email: jira_user["emailAddress"]
    }
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
