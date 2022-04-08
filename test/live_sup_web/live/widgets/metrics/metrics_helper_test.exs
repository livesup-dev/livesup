defmodule LiveSupWeb.Test.Live.Widgets.MetricsHelperTest do
  use LiveSupWeb.ConnCase
  use ExUnit.Case
  alias LiveSupWeb.Live.Widgets.Metrics.MetricsHelper

  describe "metrics helper" do
    @describetag :metrics_helper

    @widget_data %LiveSup.Core.Widgets.WidgetData{
      data: %{current_value: 581.0, name: "P95 API Latency", target: 600.0},
      icon: nil,
      icon_svg: nil,
      id: "bcee4d7d-f2b8-4b2a-9325-97f4299bf0e4",
      public_settings: %{"metric" => "p95-api-latency", "range_color_order" => "asc"},
      state: :ready,
      title: "P95 Api Latency",
      ui_settings: %{"size" => 1},
      updated_in_minutes: "08:31 UTC"
    }

    @widget_data_small_target %LiveSup.Core.Widgets.WidgetData{
      data: %{current_value: 5.41, name: "Linux OS Provision Speed", target: 8.0},
      icon: nil,
      icon_svg: nil,
      id: "0c0e32b5-e3e5-4218-be8d-62bb142c2f9d",
      public_settings: %{"metric" => "linux-os-provision-speed"},
      state: :ready,
      title: "Linux os provision speed",
      ui_settings: %{"size" => 1},
      updated_in_minutes: "08:55 UTC"
    }

    test "build_gauge/1 with big numbers" do
      result = @widget_data |> MetricsHelper.build_gauge()

      assert %{
               delta: %{reference: 600.0},
               domain: %{x: [0, 1], y: [0, 1]},
               gauge: %{
                 axis: %{range: [nil, 600.0]},
                 steps: [
                   %{color: "#12B431", range: [0, 200]},
                   %{color: "#DDD72C", range: [200, 400]},
                   %{color: "#EC8116", range: [400, 600]}
                 ],
                 bar: %{color: "#173557"}
               },
               mode: "gauge+number+delta",
               type: "indicator",
               value: 581.0
             } == result
    end

    @tag :small_metric
    test "build_gauge/1 with small target" do
      result = @widget_data_small_target |> MetricsHelper.build_gauge()

      assert %{
               delta: %{reference: 8.0},
               domain: %{x: [0, 1], y: [0, 1]},
               gauge: %{
                 axis: %{range: [nil, 8.0]},
                 steps: [
                   %{color: "#12B431", range: [0, 3]},
                   %{color: "#DDD72C", range: [3, 6]},
                   %{color: "#EC8116", range: [6, 8.0]}
                 ],
                 bar: %{color: "#173557"}
               },
               mode: "gauge+number+delta",
               type: "indicator",
               value: 5.41
             } == result
    end
  end
end
