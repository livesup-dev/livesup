defmodule LiveSup.Core.Widgets.Blameless.LastIncidents.Handler do
  alias LiveSup.Core.Datasources.BlamelessDatasource

  def get_data(
        %{
          "client_id" => _,
          "client_secret" => _,
          "audience" => _,
          "endpoint" => _,
          "limit" => limit
        } = credentials
      ) do
    BlamelessDatasource.get_incidents(
      limit: limit,
      credentials: credentials |> Map.drop(["limit"])
    )
  end
end
