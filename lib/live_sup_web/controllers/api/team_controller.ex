defmodule LiveSupWeb.Api.TeamController do
  use LiveSupWeb, :controller

  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.Team

  def index(conn, _params) do
    teams = Teams.all()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/teams/#{team.id}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get!(id)

    with {:ok, %Team{} = team} <- Teams.update(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get!(id)

    with {:ok, %Team{}} <- Teams.delete(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
