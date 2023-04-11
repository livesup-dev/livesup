defmodule LiveSupWeb.HomeControllerTest do
  use LiveSupWeb.ConnCase, async: true

  setup [:register_and_log_in_user, :setup_user_and_default_project]

  describe "home" do
    @describetag :controllers
    test "get /", %{conn: conn} do
      conn = get(conn, ~p"/")
      response = html_response(conn, 302)

      assert response =~
               "<html><body>You are being <a href=\"/projects\">redirected</a>.</body></html>"
    end
  end
end
