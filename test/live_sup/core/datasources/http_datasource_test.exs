defmodule LiveSup.Test.Core.Datasources.HttpDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Helpers.FeatureManager
  alias LiveSup.Core.Datasources.HttpDatasource

  @response """
  {
    "something": "cool!",
    "result": {
        "items": [
            {
                "public_item_id": null,
                "integrations_data": null,
                "level_lock": 0,
                "controlling_id": 1071027794,
                "last_activated_timestamp": 1618938124,
                "assigned_user_id": null,
                "group_status": 1
            }
          ]
        }
    }
  """

  @error_response """
  {
    "error":{
       "code":1002,
       "message":"API key is invalid or not provided."
    }
  }
  """

  @xml_error_response """
  <?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>
  """

  describe "HttpDatasource" do
    @describetag :datasource
    @describetag :http_datasource

    setup do
      FeatureManager.disable_mock_api()
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    test "Get data from http endpoint", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/test.com", fn conn ->
        Plug.Conn.resp(conn, 200, @response)
      end)

      {:ok, data} =
        HttpDatasource.get(
          url: endpoint_url(bypass.port, "test.com"),
          headers: []
        )

      assert "cool!" = data["something"]
    end

    test "Fail to get data from http endpoint", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/test.com", fn conn ->
        Plug.Conn.resp(conn, 401, @error_response)
      end)

      response =
        HttpDatasource.get(
          url: endpoint_url(bypass.port, "test.com"),
          headers: []
        )

      assert {
               :error,
               %{
                 "error" => %{
                   "code" => 1002,
                   "message" => "API key is invalid or not provided."
                 }
               }
             } = response
    end

    @tag :xml
    test "Fail to get data from http endpoint with an xml response", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/another.com", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/xml;charset=UTF-8")
        |> Plug.Conn.resp(401, @xml_error_response)
      end)

      response =
        HttpDatasource.get(
          url: endpoint_url(bypass.port, "another.com"),
          headers: []
        )

      assert {
               :error,
               "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><status><status-code>401</status-code><message>Client must be authenticated to access this resource.</message></status>\n"
             } = response
    end
  end

  defp endpoint_url(port, endpoint), do: "http://localhost:#{port}/#{endpoint}"
end
