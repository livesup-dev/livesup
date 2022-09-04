defmodule LiveSup.Core.Datasources.BlamelessDatasource do
  @moduledoc """
    It provides an interface to the Blameless API
  """

  use Timex
  alias LiveSup.Core.Datasources.HttpDatasource
  alias LiveSup.Helpers.DateHelper

  # https://docs.github.com/en/rest/overview/resources-in-the-rest-api#rate-limiting

  # TODO: In not proud of these functions and how we are dealing with
  # the opts, specially how are are passing the token.
  # we need to standarize/improve the way we are building these interfaces
  # https://elixirforum.com/t/passing-in-options-maps-vs-keyword-lists/1963/3
  def get_incidents(opts \\ []) do
    credentials = Keyword.fetch!(opts, :credentials)
    endpoint = credentials["endpoint"]
    filters = Keyword.get(opts, :filters, %{})
    limit = Keyword.get(opts, :limit, 10)
    number_of_days = Keyword.get(opts, :number_of_days, 100)

    case credentials |> token() do
      {:ok, token} ->
        filters =
          Map.merge(filters, %{
            limit: limit,
            offset: 0,
            order_by: "-created",
            created_from: last_n_days(number_of_days)
          })
          |> URI.encode_query()

        build_url("/api/v1/incidents?#{filters}", endpoint: endpoint)
        |> do_request(token)

      {:error, error} ->
        {:error, error |> parse_error()}
    end
  end

  def get_current_incidents(opts \\ []) do
    credentials = Keyword.fetch!(opts, :credentials)
    endpoint = credentials["endpoint"]
    number_of_days = Keyword.get(opts, :number_of_days, 7)
    limit = Keyword.get(opts, :limit, 30)

    case credentials |> token() do
      {:ok, token} ->
        filters =
          %{
            limit: limit,
            offset: 0,
            order_by: "-created",
            status: "investigating,monitoring,identified",
            created_from: last_n_days(number_of_days)
          }
          |> URI.encode_query()

        build_url("/api/v1/incidents?#{filters}", endpoint: endpoint)
        |> do_request(token)

      {:error, error} ->
        {:error, error |> parse_error()}
    end
  end

  def do_request(url, token) do
    case HttpDatasource.get(
           url: url,
           headers: token |> headers()
         ) do
      {:ok, response} -> parse_incidents(response)
      {:error, error} -> {:error, error |> parse_error()}
    end
  end

  def parse_error(%{
        "error" => error,
        "message" => message,
        "ok" => _
      }) do
    "#{error}: #{message}"
  end

  def parse_error(%{"error" => _error, "error_description" => %{"message" => message}}),
    do: message

  def parse_error(%{"error" => error, "error_description" => error_description}),
    do: "#{error}: #{error_description}"

  def parse_error(error), do: error

  def parse_incidents(%{"incidents" => entries}) do
    incidents =
      entries
      |> Enum.map(fn entry ->
        entry |> parse_incident()
      end)

    {:ok, incidents}
  end

  def parse_incident(incident) do
    created_at =
      incident["created"]["$date"]
      |> DateHelper.from_unix(:millisecond)

    %{
      created_at: created_at,
      created_at_ago: created_at |> DateHelper.from_now(),
      updated_at: incident["updated"]["$date"] |> DateHelper.from_unix(:millisecond),
      description: incident["description"],
      status: incident["status"],
      severity: incident["severity"],
      type: incident["type"],
      slack: %{
        channel: incident["slack_channel"]["name"],
        url: incident["slack_channel"]["url"]
      },
      url: incident["_id"] |> build_incident_url(),
      commander: incident |> find_commander(),
      communication_lead: incident |> find_communication_lead()
    }
  end

  def find_commander(%{"roles" => %{"commander" => commander}, "team" => team}) do
    team
    |> Enum.find(fn team_member ->
      team_member["_id"] == commander
    end)
    |> build_profile()
  end

  def find_commander(_args), do: nil

  def find_communication_lead(%{
        "roles" => %{"communication_lead" => communication_lead},
        "team" => team
      }) do
    team
    |> Enum.find(fn team_member ->
      team_member["_id"] == communication_lead
    end)
    |> build_profile()
  end

  def find_communication_lead(%{"roles" => _roles}), do: nil

  def build_profile(nil), do: nil

  def build_profile(%{"profile" => profile}) do
    %{
      full_name: profile["real_name"],
      email: profile["email"],
      avatar_url: profile["image_32"],
      title: profile["title"]
    }
  end

  def build_incident_url(id) do
    "https://livesup.blameless.io/incidents/#{id}/events"
  end

  def token(%{"client_id" => _, "client_secret" => _, "audience" => _} = credentials) do
    case HttpDatasource.post(
           url: "https://blamelesshq.auth0.com/oauth/token",
           body: credentials |> oauth_payload(),
           headers: [{"Content-Type", "application/json"}]
         ) do
      {:ok, response} -> {:ok, parse_token(response)}
      {:error, error} -> {:error, error}
    end
  end

  def headers(token) do
    [
      {"Authorization", "Bearer #{token}"}
    ]
  end

  def oauth_payload(credentials) do
    %{
      client_id: credentials["client_id"],
      client_secret: credentials["client_secret"],
      audience: credentials["audience"],
      grant_type: "client_credentials"
    }
  end

  def parse_token(%{"access_token" => access_token}), do: access_token

  def build_url(path, endpoint: endpoint) do
    "#{endpoint}#{path}"
  end

  defp last_n_days(number_of_days) do
    Timex.shift(Timex.today(), days: -1 * number_of_days) |> Timex.to_unix()
  end
end
