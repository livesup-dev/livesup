defmodule LiveSup.Core.Datasources.PagerDutyDatasource do
  @moduledoc """
    It provides an interface to the Pager Duty API. Under the hood
    it uses the HttpDataSource to perform the requests.
  """
  alias LiveSup.Core.Datasources.HttpDatasource
  use Timex

  @url "https://api.pagerduty.com/"

  def get_on_call(%{"schedule_ids" => schedule_ids, "token" => token}, args \\ []) do
    url =
      args
      |> Keyword.get(:url, @url)

    until = Timex.shift(Timex.today(), days: 20)
    schedule_ids_params = Plug.Conn.Query.encode(%{schedule_ids: schedule_ids})

    path =
      "oncalls?time_zone=UTC&earliest=true&total=false&#{schedule_ids_params}&include[]=users&until=#{until}"

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
            name: oncall_attrs["user"]["summary"],
            email: oncall_attrs["user"]["email"],
            avatar_url: oncall_attrs["user"]["avatar_url"]
          },
          start: LiveSup.Helpers.DateHelper.parse_date(oncall_attrs["start"]),
          end: oncall_attrs["end"],
          days_left:
            LiveSup.Helpers.DateHelper.diff_in_days(
              LiveSup.Helpers.DateHelper.today_as_string(),
              oncall_attrs["start"]
            )
        }
      end)
      |> Enum.sort(&(DateTime.compare(&1.start, &2.start) != :gt))
      |> Enum.take(2)

    {:ok, data}
  end

  defp process_error(%{"error" => %{"code" => code, "message" => message}}),
    do: {:error, "#{code}: #{message}"}

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
