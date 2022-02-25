defmodule LiveSup.Test.Seeds.YamlSeed do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.Projects

  describe "Seed from a yaml file" do
    @describetag :yaml_seed

    setup [:setup_groups]

    test "data is imported" do
      result = LiveSup.Seeds.YamlSeed.seed(yaml_data())

      assert :ok == result
      projects = Projects.all()

      assert length(projects)== 1

      project = Projects.get!("5727d4e3-b3d4-460c-a3fb-f0180d5c3777")
      assert project.name == "Awesome Project"
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
            - name: "Dashboard 1"
              default: false
              widgets: []
            - name: "Dashboard 2"
              default: false
              widgets: []
      """
    end
  end
end
