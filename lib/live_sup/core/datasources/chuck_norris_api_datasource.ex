defmodule LiveSup.Core.Datasources.ChuckNorrisApiDatasource do
  alias LiveSup.Core.Datasources.HttpDatasource

  # TODO: Find the way to pass this feature flag
  # into the httpdatasource
  # @feature_flag_name "chuck_api_datasource"

  @url "https://api.chucknorris.io/jokes/random"

  def get_joke() do
    %{"url" => @url}
    |> get_joke()
  end

  def get_joke(%{"url" => url}) do
    case HttpDatasource.get(url: url, headers: []) do
      {:ok, response} -> process(response)
      {:error, error} -> process_error(error)
    end
  end

  # TODO: We should probably have a better error handler
  defp process_error(error), do: {:error, error}

  defp process(%{"value" => joke}), do: {:ok, joke}
end
