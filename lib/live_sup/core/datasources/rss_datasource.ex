defmodule LiveSup.Core.Datasources.RssDatasource do
  use Timex
  import LiveSup.Core.Datasources.Helper

  def fetch(url) do
    url = build_url(url: url)

    Finch.build(:get, url)
    |> Finch.request(SupFinch)
    |> parse_response()
  end

  defp parse_response({:ok, %{body: body, status: 200}}), do: parse(body)
  defp parse_response({:ok, %{body: body, status: _}}), do: {:error, body}
  defp parse_response({:error, %Mint.TransportError{reason: :timeout}}), do: {:error, "timeout"}

  def parse(body), do: ElixirFeedParser.parse(body)
end
