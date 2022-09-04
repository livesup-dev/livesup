defmodule LiveSup.Core.Datasources.WordpressDatasource do
  @moduledoc """
    It provides an interface to the Wordpress API. Under the hood
    it uses the HttpDataSource to perform the requests.
  """
  alias LiveSup.Core.Datasources.HttpDatasource

  def directory_sizes(%{
        user: user,
        application_password: application_password,
        url: url
      }) do
    case HttpDatasource.get(
           url: build_url(url, "wp-site-health/v1/directory-sizes"),
           headers: headers(user, application_password)
         ) do
      {:ok, response} -> {:ok, process_response(response)}
      {:error, error} -> process_error(error)
    end
  end

  def site_health(%{
        user: user,
        application_password: application_password,
        url: url
      }) do
    case HttpDatasource.get(
           url: build_url(url, "wp-site-live-sup/v1/site-health"),
           headers: headers(user, application_password)
         ) do
      {:ok, response} -> {:ok, response}
      {:error, error} -> process_error(error)
    end
  end

  defp process_response(directories) do
    directories
    |> Enum.reject(fn {_key, value} -> value == 0 end)
  end

  defp process_error(%{"message" => message, "data" => %{"status" => status}}),
    do: {:error, "#{status}: #{message}"}

  defp headers(user, application_password) do
    token =
      "#{user}:#{application_password}"
      |> Base.encode64()

    [
      {"Authorization", "Basic #{token}"}
    ]
  end

  defp build_url(url, path) do
    "#{url}/wp-json/#{path}"
  end
end
