defmodule LiveSupWeb.Api.MetricControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.MetricsFixtures

  alias LiveSup.Schemas.Metric

  @create_attrs %{
    name: "some name",
    settings: %{},
    target: 120.5,
    unit: "some unit"
  }

  @update_attrs %{
    name: "some updated name",
    settings: %{},
    target: 456.7,
    unit: "some updated unit"
  }

  @invalid_attrs %{name: nil, settings: nil, slug: nil, target: nil, unit: nil}

  setup [:create_user_and_assign_valid_jwt]

  describe "index" do
    @describetag :metrics_request

    test "lists all metrics", %{conn: conn} do
      conn = get(conn, ~p"/api/metrics")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create metric" do
    @describetag :metrics_request

    test "renders metric when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/metrics", metric: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/metrics/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name",
               "settings" => %{},
               "slug" => "some-name",
               "target" => 120.5,
               "unit" => "some unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/metrics", metric: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update metric" do
    @describetag :metrics_request

    setup [:create_metric]

    test "renders metric when data is valid", %{conn: conn, metric: %Metric{id: id} = metric} do
      conn = put(conn, ~p"/api/metrics/#{metric}", metric: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/metrics/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "settings" => %{},
               "slug" => _,
               "target" => 456.7,
               "unit" => "some updated unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, metric: metric} do
      conn = put(conn, ~p"/api/metrics/#{metric}", metric: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete metric" do
    @describetag :metrics_request

    setup [:create_metric]

    test "deletes chosen metric", %{conn: conn, metric: metric} do
      conn = delete(conn, ~p"/api/metrics/#{metric}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/metrics/#{metric}")
      end
    end
  end

  defp create_metric(_) do
    metric = metric_fixture()
    %{metric: metric}
  end
end
