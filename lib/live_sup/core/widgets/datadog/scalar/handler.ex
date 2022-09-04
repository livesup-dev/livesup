defmodule LiveSup.Core.Widgets.Datadog.Scalar.Handler do
  alias LiveSup.Core.Datasources.DatadogDatasource

  def get_data(%{"query" => _, "n_days" => _, "api_key" => _, "application_key" => _} = args) do
    case args |> DatadogDatasource.get_scalar() do
      {:ok, scalar_value} -> {:ok, scalar_value}
      {:error, error} -> {:error, error}
    end
  end
end
