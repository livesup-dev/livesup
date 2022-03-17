defmodule LiveSup.Test.Core.Widgets.RssServiceStatus.Single.HandlerTest do
  use LiveSup.DataCase, async: false

  alias LiveSup.Core.Widgets.RssServiceStatus.Single.Handler
  alias LiveSup.Test.Support.Responses.RssServiceStatusResponse

  describe "Managing Rss Status" do
    @describetag :widget
    @describetag :rss_service_status_single_widget
    @describetag :rss_service_status_single_handler

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "getting service data", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "history.rss", fn conn ->
        Plug.Conn.resp(conn, 200, RssServiceStatusResponse.get())
      end)

      data =
        endpoint_url(bypass.port, "history.rss")
        |> Handler.get_data()

      assert {
               :ok,
               %{
                 created_at: ~U[2022-03-16 19:46:00Z],
                 created_at_ago: _,
                 status: :operational,
                 title: "Incident with GitHub Actions, Codespaces, Issues, and Webhooks",
                 url: "https://www.githubstatus.com/incidents/fpk08rxnqjz2"
               }
             } = data
    end
  end

  defp endpoint_url(port, endpoint), do: "http://localhost:#{port}/#{endpoint}"
end
