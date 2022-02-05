defmodule LiveSup.Core.Widgets.Blameless.IncidentsByDate.Handler do
  alias LiveSup.Core.Datasources.BlamelessDatasource

  def get_data(
        %{
          "client_id" => _,
          "client_secret" => _,
          "audience" => _,
          "limit" => limit,
          "endpoint" => _
        } = credentials
      ) do
    case BlamelessDatasource.get_incidents(
           limit: limit,
           credentials: credentials |> Map.drop(["limit"])
         ) do
      {:ok, response} -> {:ok, process(response)}
      {:error, error} -> {:error, error}
    end
  end

  def process(incidents) do
    incidents
    |> Enum.map(fn incident ->
      {:ok, only_date} = Timex.format(incident[:created_at], "{YYYY}/{M}/{D}")

      %{
        created_at: only_date,
        type: incident[:type],
        value: 1
      }
    end)
  end
end
