defmodule LiveSupWeb.Api.SeedControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.Setups

  @create_attrs %{
    data: """
    projects:
      - id: c488e97d-7a58-48e3-9696-0d7abbd365c1
        name: Testing
        slug: testing
        internal: false
        default: false
        avatar_url: https://www.someimage.com/testing.jpeg
    """
  }

  @create_with_teams_attrs %{
    data: """
    projects:
      - id: c488e97d-7a58-48e3-9696-0d7abbd365c1
        name: Testing
        slug: testing
        internal: false
        default: false
        avatar_url: https://www.someimage.com/testing.jpeg
    teams:
      - id: c92310d4-4577-4ce1-3456-be9684628ece
        name: TPM
        slug: tpm
        avatar_url: https://amazonaws.com/teams/tpm.jpeg
    """
  }

  setup [:create_user_and_assign_valid_jwt, :setup_groups]

  describe "seed" do
    @describetag :seed_request

    test "create projects", %{conn: conn} do
      conn = post(conn, ~p"/api/seed", @create_with_teams_attrs)

      assert %{"status" => "ok"} == json_response(conn, 201)
    end

    test "create projects and teams", %{conn: conn} do
      conn = post(conn, ~p"/api/seed", @create_attrs)

      assert %{"status" => "ok"} == json_response(conn, 201)
    end
  end
end
