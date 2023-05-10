defmodule LiveSupWeb.Test.Live.Team.Member.IndexTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Live.Team.Member.Index" do
    @describetag :team_member_index

    setup [:register_and_log_in_user, :setup_user_and_default_project, :setup_team]

    test "display team's members", %{conn: conn, team: %{id: id, name: team_name}} do
      {:ok, _index, html} = live(conn, ~p"/teams/#{id}/members")

      assert html =~
               "\n      #{team_name}\n    "
    end
  end
end
