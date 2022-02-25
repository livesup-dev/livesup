defmodule LiveSup.Test.Seeds.YamlSeed do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.{Projects, Dashboards}

  describe "Seed from a yaml file" do
    @describetag :yaml_seed

    setup [:setup_groups]

    test "data is imported" do
      LiveSup.Seeds.YamlSeed.seed(yaml_data())

      assert length(Projects.all()) == 1

      project = Projects.get_with_dashboards!("5727d4e3-b3d4-460c-a3fb-f0180d5c3777")
      assert %{name: "Awesome Project"} = project

      assert length(project.dashboards) == 2

      dashboard = Dashboards.get!("469430b6-d754-497d-988e-34079faafd12")
      assert %{name: "Dashboard 2"} = dashboard
    end

    defp yaml_data do
      """
      projects:
        - id: 5727d4e3-b3d4-460c-a3fb-f0180d5c3777
          name: "Awesome Project"
          slug: "awesome-project"
          internal: false
          default: false
          avatar_url: "https://awesome.com/my-awesome-project.jpeg"
          dashboards:
            - id: af65c472-40cb-4824-8224-708cec8806de
              name: "Dashboard 1"
              default: false
              widgets: []
            - id: 469430b6-d754-497d-988e-34079faafd12
              name: "Dashboard 2"
              default: false
              widgets: []
      """
    end
  end
end
