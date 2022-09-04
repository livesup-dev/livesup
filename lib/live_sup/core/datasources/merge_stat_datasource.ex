defmodule LiveSup.Core.Datasources.MergeStatDatasource do
  @moduledoc """
    It provides an interface to the MergeStat API
  """
  alias LiveSup.Core.Datasources.HttpDatasource

  @url "https://try.askgit.com/api/query"

  def run_query(%{"repo" => _repo, "query" => _query} = body, args \\ []) do
    url = Keyword.get(args, :url, @url)

    case HttpDatasource.post(
           url: url,
           body: body,
           headers: headers()
         ) do
      {:ok, response} -> {:ok, process_response(response)}
      {:error, error} -> {:error, error}
    end
  end

  defp process_response(%{"rows" => rows}), do: rows

  # The API is pretty new, so it doesn't handle errors correctly
  # defp process_error(%{"message" => message, "data" => %{"status" => status}}),
  #   do: {:error, "#{status}: #{message}"}

  defp headers() do
    [
      {"accept", "application/json, text/plain, */*"},
      {"content-type", "application/json;charset=UTF-8"}
    ]
  end
end
