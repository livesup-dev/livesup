defmodule LiveSup.Core.Widgets.Datadog.Scalar.Handler do
  alias LiveSup.Core.Datasources.DatadogDatasource

  def get_data(%{"query" => _, "n_days" => _, "api_key" => _, "application_key" => _} = args) do
    with {:ok, scalar_value} <- args |> DatadogDatasource.get_scalar() do
      {:ok, scalar_value}
    else
      {:error, error} -> {:error, error}
    end
  end
end
