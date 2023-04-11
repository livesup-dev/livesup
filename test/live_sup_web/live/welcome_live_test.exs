defmodule LiveSupWeb.Test.Live.WelcomeLive do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest
  import LiveSup.Test.TeamsFixtures

  defp create_teams(_) do
    team_a = team_fixture(%{name: "Team A"})
    team_b = team_fixture(%{name: "Team B"})
    %{team_a: team_a, team_b: team_b}
  end

  describe "Index" do
    @describetag :welcome

    setup [:register_and_log_in_user, :create_teams]

    test "lists all teams", %{conn: conn, team_a: team_a, team_b: team_b} do
      {:ok, _index_live, html} = live(conn, ~p"/welcome/teams")

      assert html =~ team_a.name
      assert html =~ team_b.name
    end
  end
end
