defmodule LiveSup.Test.DataImporter.UserLinkImporterTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.Links
  alias LiveSup.DataImporter.Users.LinkImporter

  @links [
    %{
      "settings" => %{
        "username" => "kidush"
      },
      "datasource_slug" => "github-datasource"
    },
    %{
      "settings" => %{
        "account_id" => "62a3c56176c0360069f5f7c7"
      },
      "datasource_slug" => "jira-datasource"
    }
  ]

  describe "Import from a yaml file" do
    @describetag :importer_user_links

    setup [:setup_user, :setup_jira_datasource, :setup_github_datasource]

    test "data is imported", %{user: user} do
      assert Links.count() == 0

      user
      |> LinkImporter.perform(@links)

      assert Links.count() == 2

      # re run the import to make sure we don't duplicate data
      user
      |> LinkImporter.perform(@links)

      assert Links.count() == 2
    end
  end
end
