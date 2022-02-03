defmodule LiveSup.Core.Widgets.Blameless.IncidentsByType.Handler do
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
    |> Enum.reduce(%{}, fn incident, acc ->
      Map.update(acc, incident[:type], 1, fn count -> count + 1 end)
    end)
  end
end
