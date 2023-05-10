defmodule LiveSupWeb.Test.Live.Team.IndexTest do
  use LiveSupWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Live.Team.Index" do
    @describetag :team_index

    setup [:register_and_log_in_user, :setup_team]

    test "display teams", %{conn: conn, team: %{name: team_name}} do
      {:ok, _index, html} = live(conn, ~p"/teams")

      assert html =~
               "\n#{team_name}\n        "
    end
  end
end
