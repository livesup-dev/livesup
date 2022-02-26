defmodule LiveSup.Test.Seeds.YamlSeed do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.{Projects, Dashboards, Widgets, Datasources}

  describe "Seed from a yaml file" do
    @describetag :yaml_seed

    setup [:setup_groups, :weather_widget_fixture]

    test "data is imported" do
      LiveSup.Seeds.YamlSeed.seed(yaml_data())

      assert length(Projects.all()) == 1

      project = Projects.get_with_dashboards!("5727d4e3-b3d4-460c-a3fb-f0180d5c3777")
      assert %{name: "Awesome Project"} = project

      assert length(project.dashboards) == 2

      dashboard = Dashboards.get!("af65c472-40cb-4824-8224-708cec8806de")
      assert %{name: "Dashboard 1"} = dashboard

      widget_instances = Dashboards.widgets_instances(dashboard)
      assert length(widget_instances) == 1
    end

    defp yaml_data do
      """
      projects:
        -
          avatar_url: "https://awesome.com/my-awesome-project.jpeg"
          dashboards:
            -
              default: false
              id: af65c472-40cb-4824-8224-708cec8806de
              name: "Dashboard 1"
              widgets:
                -
                  datasource_slug: weather-api-datasource
                  widget_slug: weather
                  enabled: true
                  feature_image_url: /images/widgets/weather.png
                  global: false
                  labels: []
                  name: Weather
                  settings:
                    location:
                      source: local
                      type: string
                      value: ""
                    runs_every:
                      source: local
                      type: int
                      value: 43200
                  slug: weather
                  ui_handler: LiveSupWeb.Live.Widgets.WeatherLive"
                  worker_handler: LiveSup.Core.Widgets.Weather.Worker
            -
              default: false
              id: 469430b6-d754-497d-988e-34079faafd12
              name: "Dashboard 2"
              widgets: []
          default: false
          id: 5727d4e3-b3d4-460c-a3fb-f0180d5c3777
          internal: false
          name: "Awesome Project"
          slug: awesome-project

      """
    end
  end

  def weather_widget_fixture(_) do
    %{
      name: "Weather API Datasource",
      slug: "weather-api-datasource",
      enabled: true,
      labels: [],
      settings: %{"api_key" => nil}
    }
    |> Datasources.create()
    |> weather_widget()
  end

  def weather_widget({:ok, datasource}) do
    %{
      name: "Weather",
      slug: "weather",
      enabled: true,
      global: false,
      feature_image_url: "/images/widgets/weather.png",
      ui_handler: "LiveSupWeb.Live.Widgets.WeatherLive",
      worker_handler: "LiveSup.Core.Widgets.Weather.Worker",
      labels: [],
      settings: %{
        # 12 hours
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 43200},
        "location" => %{"source" => "local", "type" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
    |> Widgets.create!()

    :ok
  end
end
