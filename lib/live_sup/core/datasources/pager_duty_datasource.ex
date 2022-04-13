defmodule LiveSup.Core.Datasources.PagerDutyDatasource do
  alias LiveSup.Core.Datasources.HttpDatasource

  @url "https://api.pagerduty.com/"

  def get_on_call(%{"schedule_ids" => schedule_ids, "token" => token}, args \\ []) do
    url =
      args
      |> Keyword.get(:url, @url)

    schedule_ids_params = Plug.Conn.Query.encode(%{schedule_ids: schedule_ids})
    path = "oncalls?time_zone=UTC&total=false&#{schedule_ids_params}"

    case HttpDatasource.get(url: build_url(url, path), headers: headers(token)) do
      {:ok, response} -> process(response)
      {:error, error} -> process_error(error)
    end
  end

  def process(%{"oncalls" => oncalls}) do
    data =
      oncalls
      |> Enum.map(fn oncall_attrs ->
        %{
          id: oncall_attrs["id"],
          name: oncall_attrs["schedule"],
          user: %{
            id: oncall_attrs["user"]["id"],
            name: oncall_attrs["user"]["summary"]
          },
          start: "2022-04-11T09:00:00Z",
          end: "2022-04-18T09:00:00Z"
        }
      end)

    {:ok, data}
  end

  defp process_error(error), do: {:error, error}

  defp build_url(url, path) do
    "#{url}/#{path}"
  end

  def headers(token) do
    [
      {"Authorization", "Token token=#{token}"},
      {"Content-Type", "application/json"}
    ]
  end
end
