defmodule LiveSup.Test.DataImporter.Importer do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.{Projects, Dashboards, Widgets, Datasources, Teams, Metrics, Todos}
  alias LiveSup.Queries.{MetricValueQuery, DatasourceInstanceQuery}
  alias LiveSup.Schemas.{Dashboard, WidgetInstance}
  alias LiveSup.Test.ProjectsFixtures

  describe "Import from a yaml file" do
    @describetag :importer

    setup [:setup_groups, :weather_widget_fixture]

    test "data is imported" do
      assert DatasourceInstanceQuery.count() == 0
      LiveSup.DataImporter.Importer.import(yaml_data())

      assert length(Projects.all()) == 1

      project = Projects.get_with_dashboards!("5727d4e3-b3d4-460c-a3fb-f0180d5c3777")
      assert %{name: "Awesome Project"} = project

      assert length(project.dashboards) == 2

      dashboard = Dashboards.get!("af65c472-40cb-4824-8224-708cec8806de")
      assert %{name: "Dashboard 1"} = dashboard

      widget_instances = Dashboards.widgets_instances(dashboard)
      assert length(widget_instances) == 1

      team = Teams.get!("c92310d4-4577-4ce1-3456-be9684628ece")
      assert %{name: "TPM"} = team

      widget_instance = Widgets.get_instance!("8622c22c-5535-4502-a526-cef8f64ae57a")
      assert %{name: "Weather"} = widget_instance

      metric = Metrics.get!("1dadc794-f202-47fd-aa83-3fff64e93edc")
      assert %{name: "Acquire 10,000 Users"} = metric

      metric_value = MetricValueQuery.get!("b463a353-9955-43bb-a447-7eb53504143e")
      assert %{value: 5.0e3} = metric_value

      dashboard_widget =
        Dashboards.get_instance(
          %Dashboard{id: "af65c472-40cb-4824-8224-708cec8806de"},
          %WidgetInstance{id: "8622c22c-5535-4502-a526-cef8f64ae57a"}
        )

      assert %{
               dashboard_id: "af65c472-40cb-4824-8224-708cec8806de",
               widget_instance_id: "8622c22c-5535-4502-a526-cef8f64ae57a"
             } = dashboard_widget

      dashboard_widget =
        Dashboards.get_instance(
          %Dashboard{id: "469430b6-d754-497d-988e-34079faafd12"},
          %WidgetInstance{id: "8622c22c-5535-4502-a526-cef8f64ae57a"}
        )

      assert %{
               dashboard_id: "469430b6-d754-497d-988e-34079faafd12",
               widget_instance_id: "8622c22c-5535-4502-a526-cef8f64ae57a"
             } = dashboard_widget

      assert DatasourceInstanceQuery.count() == 1

      todo = Todos.get!("cd5c19b7-a460-4a42-a64a-937dfad3f3f3")
      assert %{title: "Elixir projects"} = todo

      first_datasource = todo.datasources |> Enum.at(0)
      assert length(todo.datasources) == 2
      assert %{"location" => %{"value" => "Mahon"}} = first_datasource.settings

      # Make sure it does not fail when running twice
      LiveSup.DataImporter.Importer.import(yaml_data())

      assert DatasourceInstanceQuery.count() == 1
    end
  end

  describe "importing data when we already have data" do
    @describetag :importer

    setup(context) do
      setup_groups(context)

      project = ProjectsFixtures.project_fixture()
      {:ok, project: project}
    end

    test "data is cleaned and imported", %{project: project} do
      LiveSup.DataImporter.Importer.import(yaml_clean())

      assert project.id |> Projects.get() == nil
    end
  end

  defp yaml_clean do
    """
    remove_existing_projects: true
    projects:
      -
        avatar_url: "https://awesome.com/my-awesome-project.jpeg"
        default: false
        id: 5727d4e3-b3d4-460c-a3fb-f0180d5c3777
        internal: false
        name: "Awesome Project"
        slug: awesome-project
        dashboards:
          -
            default: false
            id: af65c472-40cb-4824-8224-708cec8806de
            name: "Dashboard 1"
    """
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
                id: 8622c22c-5535-4502-a526-cef8f64ae57a
                datasource_slug: weather-api-datasource
                widget_slug: weather
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
            widgets:
              -
                id: 8622c22c-5535-4502-a526-cef8f64ae57a
                datasource_slug: weather-api-datasource
                widget_slug: weather
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
        default: false
        id: 5727d4e3-b3d4-460c-a3fb-f0180d5c3777
        internal: false
        name: "Awesome Project"
        slug: awesome-project
        projects:
        - id: c488e97d-7a58-48e3-9696-0d7abbd365c1
          name: Testing
          slug: testing
          internal: false
          default: false
          avatar_url: https://www.someimage.com/testing.jpeg
    teams:
      - id: c92310d4-4577-4ce1-3456-be9684628ece
        name: TPM
        slug: tpm
        avatar_url: https://amazonaws.com/teams/tpm.jpeg
    metrics:
      - id: 1dadc794-f202-47fd-aa83-3fff64e93edc
        name: Acquire 10,000 Users
        slug: acquire-10000-users
        target: 10000
        unit: count
        labels:
          - rocks
        values:
          - id: b463a353-9955-43bb-a447-7eb53504143e
            value: 5000
            value_date: 2022-03-18 00:00:00
          - id: 8f871123-54fd-4749-9030-fd520c016bbd
            value: 2000
            value_date: 2022-03-14 00:00:00
    todos:
      - id: cd5c19b7-a460-4a42-a64a-937dfad3f3f3
        title: Elixir projects
        datasources:
          -
            id: 3f9adddb-1180-41a4-bda5-20018c9c5ef4
            slug: weather-api-datasource
            settings:
              location:
                source: local
                type: string
                value: Mahon
              runs_every:
                source: local
                type: int
                value: 43200
          -
            id: d5e6c027-2fb3-4a0b-b712-d94ebc5035aa
            slug: weather-api-datasource
            settings:
              location:
                source: local
                type: string
                value: Madrid
              runs_every:
                source: local
                type: int
                value: 43200
    """
  end

  def weather_widget_fixture(_) do
    %{
      name: "Weather API Datasource",
      slug: "weather-api-datasource",
      enabled: true,
      labels: [],
      settings: %{"api_key" => nil}
    }
    |> Datasources.find_or_create()
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
        "runs_every" => %{"source" => "local", "type" => "int", "value" => 43_200},
        "location" => %{"source" => "local", "type" => "string", "value" => ""}
      },
      datasource_id: datasource.id
    }
    |> Widgets.find_or_create()

    :ok
  end
end
