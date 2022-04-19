defmodule LiveSup.Core.Datasources.RollbarDatasource do
  alias LiveSup.Core.Datasources.HttpDatasource
  alias LiveSup.Helpers.{DateHelper, StringHelper}

  @url "https://api.rollbar.com/api/1"

  def get_issues(%{"env" => env, "limit" => limit, "status" => status} = params, args \\ []) do
    url =
      args
      |> Keyword.get(:url, @url)

    token =
      args
      |> Keyword.fetch!(:token)

    status = status || "active"

    projects_params = params |> build_projects_param()

    IO.inspect("#{url}/items?level=error&status=#{status}&environment=#{env}&#{projects_params}")

    case HttpDatasource.get(
           url: "#{url}/items?level=error&status=#{status}&environment=#{env}&#{projects_params}",
           headers: headers(token)
         ) do
      {:ok, response} -> {:ok, process_response(response, limit)}
      {:error, error} -> {:error, process_error(error)}
    end
  end

  defp build_projects_param(%{"projects" => projects}) do
    Plug.Conn.Query.encode(%{projects: projects})
  end

  defp build_projects_param(_), do: ""

  def process_response(%{"result" => %{"items" => items}}, limit) do
    items
    |> Enum.map(fn item -> build_issue(item) end)
    |> Enum.take(limit)
  end

  def process_error(%{"err" => _, "message" => message}), do: message

  def process_error(message), do: message

  def build_issue(%{"last_occurrence_timestamp" => last_occurrence_timestamp} = issue) do
    last_occurrence =
      last_occurrence_timestamp
      |> DateTime.from_unix!()

    %{
      title: issue["title"],
      short_title: StringHelper.truncate(issue["title"], max_length: 50),
      counter: issue["counter"],
      total_occurrences: issue["total_occurrences"],
      last_occurrence: last_occurrence,
      last_occurrence_ago: from_now(last_occurrence),
      url: "https://rollbar.com/[TBD]/items/#{issue["counter"]}/"
    }
  end

  defp from_now(date), do: DateHelper.from_now(date)

  def headers(token) do
    [
      {"X-Rollbar-Access-Token", token || ""}
    ]
  end
end
