defmodule LiveSup.Core.Widgets.Blameless.CurrentIncidents.Handler do
  alias LiveSup.Core.Datasources.BlamelessDatasource

  def get_data(
        %{"client_id" => _, "client_secret" => _, "audience" => _, "endpoint" => _} = credentials
      ) do
    BlamelessDatasource.get_current_incidents(credentials: credentials)
  end
end
