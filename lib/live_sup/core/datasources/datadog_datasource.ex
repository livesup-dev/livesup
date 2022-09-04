defmodule LiveSup.Core.Datasources.DatadogDatasource do
  @moduledoc """
    It provides an interface to the Datadog API
  """

  use Timex
  alias LiveSup.Core.Datasources.HttpDatasource

  # https://docs.datadoghq.com/api/latest/rate-limits/

  @url "https://app.datadoghq.com"

  def get_scalar(
        %{
          "query" => query,
          "n_days" => n_days,
          "api_key" => api_key,
          "application_key" => application_key
        },
        args \\ []
      ) do
    url =
      args
      |> Keyword.get(:url, @url)

    case HttpDatasource.post(
           url: build_url(url, "/query/scalar"),
           body: scalar_body(query, n_days),
           headers: headers(api_key, application_key)
         ) do
      {:ok, response} -> process_scalar(response)
      {:error, error} -> process_error(error)
    end
  end

  defp process_scalar(%{"data" => [element]}) do
    %{
      "attributes" => %{
        "columns" => [
          %{
            "values" => value
          }
        ]
      }
    } = element

    parsed_value =
      if Enum.empty?(value) do
        0
      else
        value
        |> List.first()
      end

    # TODO: We need to find a way to convert this value
    # to the real unit
    {:ok, %{value: parsed_value * 1000}}
  end

  defp process_error(error), do: {:error, error}

  defp scalar_body(query, n_days) do
    today = DateTime.utc_now()

    from =
      today
      |> Timex.shift(days: -1 * n_days)
      |> DateTime.to_unix(:millisecond)

    to =
      DateTime.utc_now()
      |> DateTime.to_unix(:millisecond)

    %{
      data: [
        %{
          type: "scalar_request",
          attributes: %{
            formulas: [
              %{
                formula: "query1"
              }
            ],
            queries: [
              %{
                query: query,
                data_source: "metrics",
                name: "query1",
                aggregator: "percentile"
              }
            ],
            from: from,
            to: to
          }
        }
      ]
    }
  end

  def headers(api_key, application_key) do
    [
      {"DD-API-KEY", api_key || ""},
      {"DD-APPLICATION-KEY", application_key || ""}
    ]
  end

  def build_url(url, path) do
    "#{url}/api/v2#{path}"
  end
end
