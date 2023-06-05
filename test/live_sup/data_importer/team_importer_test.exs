defmodule LiveSup.Test.DataImporter.TeamImporterTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  import LiveSup.Test.Setups

  alias LiveSup.Core.{Teams, Users}
  alias LiveSup.Queries.{TeamQuery}

  describe "Import from a yaml file" do
    @describetag :importer_team

    setup [:setup_groups]

    test "data is imported" do
      assert TeamQuery.count() == 0
      assert Users.count() == 0

      yaml_data()
      |> LiveSup.DataImporter.TeamImporter.perform()

      assert length(Teams.all()) == 2
      assert Users.count() == 2

      team = Teams.get("3178f97d-02eb-4a83-9054-9865e5eba3b9")
      assert team.name == "Billing"
      assert team.slug == "billing"
      assert team.avatar == "money_bag"
      assert team.team_members == []

      awesome_team = Teams.get("aa37a252-4529-4471-8bbf-f29fac555679")
      assert awesome_team.name == "My Awesome Team"
      assert awesome_team.slug == "my-awesome-team"
      assert awesome_team.avatar == "spiral_shell"
      assert length(awesome_team.team_members) == 2

      peter = Users.get("b3aea1fb-6656-4652-b4b4-e529ef27fed6")
      assert peter.first_name == "Peter"
      assert peter.last_name == "Pan"
      assert peter.email == "peterpan@livesup.com"

      assert peter.location == %{
               "city" => "Mahon",
               "country" => "Spain",
               "lat" => 9.9991163,
               "lng" => 9.9991163,
               "state" => "Balearic Islands",
               "timezone" => "Europe/Madrid",
               "zip_code" => 7720
             }

      # re run the import to make sure we don't duplicate data
      yaml_data()
      |> LiveSup.DataImporter.TeamImporter.perform()

      assert length(Teams.all()) == 2
    end
  end

  describe "importing data when we already have data" do
    @describetag :importer_team

    setup [:setup_groups, :setup_team]

    test "data is cleaned and imported" do
      assert length(Teams.all()) == 1
      LiveSup.DataImporter.Importer.perform(yaml_clean())

      assert length(Teams.all()) == 1

      team = Teams.get("3178f97d-02eb-4a83-9054-9865e5eba3b9")
      assert team.name == "Billing"
      assert team.slug == "billing"
      assert team.avatar == "money_bag"
      assert team.team_members == []
    end
  end

  defp yaml_clean do
    """
    remove_existing_teams: true
    teams:
      - id: 3178f97d-02eb-4a83-9054-9865e5eba3b9
        name: "Billing"
        slug: "billing"
        avatar: "money_bag"
    """
  end

  defp yaml_data do
    """
    teams:
      - id: 3178f97d-02eb-4a83-9054-9865e5eba3b9
        name: "Billing"
        slug: "billing"
        avatar: "money_bag"
      - id: aa37a252-4529-4471-8bbf-f29fac555679
        name: "My Awesome Team"
        slug: "my-awesome-team"
        avatar: "spiral_shell"
        members:
          - id: b3aea1fb-6656-4652-b4b4-e529ef27fed6
            first_name: "Peter"
            last_name: "Pan"
            email: "peterpan@livesup.com"
            location:
              timezone: Europe/Madrid
              city: Mahon
              state: Balearic Islands
              country: Spain
              zip_code: 07720
              lat: 9.9991163
              lng: 9.9991163
          - id: 3e27aabc-c0f4-4438-a6bd-138d4355c9ab
            first_name: "Wendy"
            last_name: "Darling"
            email: "wendy.darling@eu.livesup.com"
            location:
              timezone: Europe/Madrid
              city: Es Castell
              state: Balearic Islands
              country: Spain
              zip_code: 07720
              lat: 9.9991163
              lng: 9.9991163
    """
  end
end
