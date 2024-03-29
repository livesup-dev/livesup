defmodule LiveSup.Test.Core.TeamsTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Core.{Teams}
  alias LiveSup.Schemas.Team
  alias LiveSup.Test.{ProjectsFixtures, AccountsFixtures}

  describe "teams" do
    @describetag :teams

    alias LiveSup.Schemas.Team

    @name "My Team"
    @valid_attrs %{
      name: @name,
      labels: ["my_team"],
      global: true,
      settings: %{some_custom_setting: 5}
    }
    @update_attrs %{name: "My Cool Team"}
    @invalid_attrs %{name: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Teams.create()

      # We have to reload the team
      # otherwise the settings attribute uses atoms
      # instead of strings
      Teams.get!(team.id)
    end

    setup do
      team = team_fixture(@valid_attrs)
      project = ProjectsFixtures.project_fixture()

      team_with_project =
        team_fixture(
          @valid_attrs
          |> Map.merge(%{project: project.id, name: "Team 2"})
        )

      {:ok, team: team, team_with_project: team_with_project, project: project}
    end

    test "all/0 returns all teams" do
      teams = Teams.all() |> Enum.sort()
      assert length(teams) == 2
    end

    test "all/1 returns all teams by project", %{
      project: project,
      team: team,
      team_with_project: team_with_project
    } do
      project_x = ProjectsFixtures.project_fixture()

      team_fixture(
        @valid_attrs
        |> Map.merge(%{project_id: project_x.id, name: "Team 3"})
      )

      teams = Teams.all(project)
      assert length(teams) == 2

      teams_ids = teams |> Enum.map(&Map.get(&1, :id)) |> Enum.sort()
      assert teams_ids == [team.id, team_with_project.id] |> Enum.sort()
    end

    test "get!/1 returns the team with given id", %{team: team} do
      assert Teams.get!(team.id) == team
    end

    test "members/1 returns the team with given id", %{team: team} do
      user_1 = AccountsFixtures.user_fixture()
      Teams.add_member(team, user_1)
      user_2 = AccountsFixtures.user_fixture()
      Teams.add_member(team, user_2)

      members = Teams.members(team.id)

      members_ids =
        members
        |> Enum.map(&Map.get(&1, :user_id))
        |> Enum.sort()

      assert length(members) == 2
      assert members_ids == [user_1.id, user_2.id] |> Enum.sort()
    end

    test "create/1 with valid data creates a widget" do
      assert {:ok, %Team{} = team} =
               Teams.create(
                 @valid_attrs
                 |> Map.merge(%{name: "Team 4"})
               )

      assert team.labels == ["my_team"]
      assert team.name == "Team 4"
      assert team.settings == %{some_custom_setting: 5}
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the widget", %{team: team} do
      assert {:ok, %Team{} = team} = Teams.update(team, @update_attrs)
      assert team.labels == ["my_team"]
      assert team.name == "My Cool Team"
      assert team.settings == %{"some_custom_setting" => 5}
    end

    test "update/2 with invalid data returns error changeset", %{team: team} do
      assert {:error, %Ecto.Changeset{}} = Teams.update(team, @invalid_attrs)
      assert team == Teams.get!(team.id)
    end

    test "delete/1 deletes the team", %{team: team} do
      assert {:ok, %Team{}} = Teams.delete(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get!(team.id) end
    end

    test "change/1 returns a team changeset", %{team: team} do
      assert %Ecto.Changeset{} = Teams.change(team)
    end
  end
end
