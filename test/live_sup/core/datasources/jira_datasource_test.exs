defmodule LiveSup.Test.Core.Datasources.JiraDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Helpers.FeatureManager
  alias LiveSup.Core.Datasources.JiraDatasource

  @response """
    {
      "maxResults": 50,
      "startAt": 0,
      "isLast": true,
      "values": [
          {
              "id": 431,
              "self": "https://livesup.atlassian.net/rest/agile/1.0/sprint/431",
              "state": "active",
              "name": "Livesup Sprint 10-21",
              "startDate": "2021-05-18T14:45:51.832Z",
              "endDate": "2021-06-01T17:38:00.000Z",
              "originBoardId": 145,
              "goal": "Some cool goal description."
          }
      ]
    }
  """

  @xml_error_response """
  <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>
  """

  describe "jira datasource" do
    @describetag :jira_datasource
    @describetag :datasource

    setup do
      FeatureManager.disable_mock_api()
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :jira_current_sprint
    test "Get current sprint", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          Plug.Conn.resp(conn, 200, @response)
        end
      )

      {:ok, data} =
        JiraDatasource.get_current_sprint(
          "145",
          token: "xxxx",
          domain: endpoint_url(bypass.port)
        )

      assert %{
               days_left: _,
               endDate: "2021-06-01T17:38:00.000Z",
               goal: "Some cool goal description.",
               id: 431,
               name: "Livesup Sprint 10-21",
               startDate: "2021-05-18T14:45:51.832Z",
               state: "active"
             } = data
    end

    @tag datasource: true, jira_datasource: true
    test "Failing getting the current sprint", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/rest/agile/1.0/board/145/sprint",
        fn conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/xml;charset=UTF-8")
          |> Plug.Conn.resp(401, @xml_error_response)
        end
      )

      data =
        JiraDatasource.get_current_sprint(
          "145",
          token: "xxxxx",
          domain: endpoint_url(bypass.port)
        )

      assert {:error,
              "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>\n"} =
               data
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"
  end
end
