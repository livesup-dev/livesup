defmodule LiveSup.Core.Datasources.HttpDatasource do
  use Timex

  import Logger
  import LiveSup.Core.Datasources.Helper
  alias LiveSup.Helpers.StringHelper

  @feature_flag_name "http_datasource"

  def get(url: url, headers: headers) do
    manage_request(:get, url, headers)
  end

  def post(url: url, body: body, headers: headers) do
    manage_request(:post, url, body, headers)
  end

  defp manage_request(action, url, body, headers) do
    url = build_url(url: url, feature_flag: @feature_flag_name)

    debug("HttpDatasource: #{url}")

    Finch.build(action, url, headers, body |> Jason.encode!())
    |> Finch.request(SupFinch)
    |> execute
  end

  defp manage_request(action, url, headers) do
    url = build_url(url: url, feature_flag: @feature_flag_name)

    debug("HttpDatasource: #{url}")

    Finch.build(action, url, headers)
    |> Finch.request(SupFinch)
    |> execute
  rescue
    e in ArgumentError -> {:error, StringHelper.truncate(e.message, max_length: 50)}
  end

  defp execute({_, %Finch.Response{headers: headers}} = request) do
    content_type = headers |> find_content_type()

    case request do
      {:ok, %Finch.Response{body: body, status: 200}} ->
        parse(body)

      {:ok, %Finch.Response{body: _body, status: 405}} ->
        {:error, "405: Method not allowed"}

      {:ok, %Finch.Response{body: body, status: 400 = status}} ->
        {:error, "#{status}: #{body}"}

      {:ok, %Finch.Response{body: body, status: 500} = _response} ->
        {:error, "500: #{body |> error_message()}"}

      {:ok, %Finch.Response{body: body}} ->
        parse_error(body, content_type)

      {:error, error} ->
        {:error, error}
    end
  end

  defp error_message(""), do: "Something happened, but we don't have too many details"
  defp error_message(nil), do: "Something happened, but we don't have too many details"
  defp error_message(body), do: body

  defp parse(body), do: {:ok, body |> Jason.decode!()}
  defp parse_error(body, "application/xml;charset=UTF-8"), do: {:error, body}
  defp parse_error(body, "text/html; charset=utf-8"), do: {:error, body}
  defp parse_error(body, _), do: {:error, body |> Jason.decode!()}

  defp find_content_type(headers) do
    headers
    |> List.keyfind("content-type", 0)
    |> get_content_type_value()
  end

  defp get_content_type_value(nil), do: nil
  defp get_content_type_value(touple), do: touple |> elem(1)
end
