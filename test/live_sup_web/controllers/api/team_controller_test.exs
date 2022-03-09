defmodule LiveSupWeb.Api.TeamControllerTest do
  use LiveSupWeb.ConnCase

  import LiveSup.Test.TeamsFixtures

  alias LiveSup.Schemas.Team

  @create_attrs %{
    avatar_url: "www.image.com/something.jpg",
    name: "some name"
  }
  @update_attrs %{
    avatar_url: "www.image.com/something2.jpg",
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @describetag :teams_request

    test "lists all teams", %{conn: conn} do
      conn = get(conn, Routes.api_team_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    @describetag :teams_request

    test "renders team when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_team_path(conn, :create), team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_team_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "avatar_url" => "www.image.com/something.jpg",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_team_path(conn, :create), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    @describetag :teams_request
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put(conn, Routes.api_team_path(conn, :update, team), team: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_team_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "avatar_url" => "www.image.com/something2.jpg",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, Routes.api_team_path(conn, :update, team), team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    @describetag :teams_request
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete(conn, Routes.api_team_path(conn, :delete, team))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_team_path(conn, :show, team))
      end
    end
  end

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end
end
