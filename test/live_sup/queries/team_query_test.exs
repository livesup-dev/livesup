defmodule LiveSup.Tests.Queries.TeamQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.TeamQuery
  alias LiveSup.Test.{TeamsFixtures, AccountsFixtures}
  alias LiveSup.Core.Teams

  import LiveSup.Test.Setups

  def setup_teams(_) do
    user = AccountsFixtures.user_fixture()

    team = TeamsFixtures.team_fixture()

    team |> Teams.add_member(user)

    %{team: team, user: user}
  end

  setup [:setup_teams]

  describe "managing team queries" do
    @describetag :team_query

    test "getting team details", %{team: %{id: team_id}} do
      team = team_id |> TeamQuery.get()
      assert team.id == team_id
    end

    test "deleting team's members", %{team: team} do
      {deleted_members, nil} = team |> TeamQuery.delete_members()
      assert deleted_members == 1
    end
  end
end
