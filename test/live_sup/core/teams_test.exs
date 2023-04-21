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

    test "all/0 returns all teams", %{team: team, team_with_project: team_with_project} do
      teams = Teams.all() |> Enum.sort()
      created_teams = [team, team_with_project] |> Enum.sort()
      assert length(teams) == length(created_teams)
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

      assert Teams.all(project) == [team, team_with_project]
    end

    test "get!/1 returns the team with given id", %{team: team} do
      assert Teams.get!(team.id) == team
    end

    test "members/1 returns the team with given id", %{team: team} do
      user_1 = AccountsFixtures.user_fixture()
      Teams.add_member(team, user_1)
      user_2 = AccountsFixtures.user_fixture()
      Teams.add_member(team, user_2)

      assert Teams.members(team.id) == [user_1, user_2]
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
