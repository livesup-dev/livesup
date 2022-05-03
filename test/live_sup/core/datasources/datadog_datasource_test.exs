defmodule LiveSup.Test.Core.Datasources.DatadogDatasourceTest do
  use LiveSup.DataCase, async: true

  alias LiveSup.Core.Datasources.DatadogDatasource

  describe "Datadog datasource" do
    @describetag :datadog_datasource
    @describetag :datasource

    setup do
      bypass = Bypass.open()
      {:ok, bypass: bypass}
    end

    @tag :datadog_get_scalar
    test "Get scalar", %{bypass: bypass} do
      Bypass.expect_once(
        bypass,
        "POST",
        "/api/v2/query/scalar",
        fn conn ->
          Plug.Conn.resp(conn, 200, scalar_response())
        end
      )

      {:ok, data} =
        DatadogDatasource.get_scalar(
          %{
            "query" => "query-test",
            "n_days" => 5,
            "api_key" => "xxxx",
            "application_key" => "xxxx"
          },
          url: endpoint_url(bypass.port)
        )

      assert %{value: 0.6280373478063627} = data
    end

    defp endpoint_url(port), do: "http://localhost:#{port}"

    defp scalar_response() do
      """
      {
          "meta": {
              "res_type": "scalar",
              "responses": []
          },
          "data": [
              {
                  "type": "scalar_response",
                  "attributes": {
                      "columns": [
                          {
                              "type": "number",
                              "meta": {
                                  "unit": [
                                      {
                                          "scale_factor": 1.0,
                                          "name": "second",
                                          "family": "time",
                                          "short_name": "s",
                                          "plural": "seconds",
                                          "id": 11
                                      },
                                      null
                                  ]
                              },
                              "values": [
                                  0.6280373478063627
                              ],
                              "name": "query1"
                          }
                      ]
                  }
              }
          ]
      }
      """
    end
  end
end
