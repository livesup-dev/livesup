defmodule LiveSup.Core.Datasources.RssDatasource do
  use Timex
  import LiveSup.Core.Datasources.Helper

  def fetch(url) do
    url = build_url(url: url)

    Finch.build(:get, url)
    |> Finch.request(SupFinch)
    |> parse_response(url)
  end

  defp parse_response({:ok, %{body: body, status: 200}}, _url), do: parse(body)
  defp parse_response({:ok, %{body: body, status: _}}, _url), do: {:error, body}

  defp parse_response({:error, %Mint.TransportError{reason: :timeout}}, _url),
    do: {:error, "timeout"}

  defp parse_response({:error, %Mint.TransportError{reason: :nxdomain}}, url),
    do: {:error, "nxdomain: #{url}"}

  def parse(body), do: ElixirFeedParser.parse(body)
end
