defmodule LiveSupWeb.Api.TeamJSON do
  alias LiveSup.Schemas.Team

  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  def show(%{team: team}) do
    %{data: data(team)}
  end

  def data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      slug: team.slug,
      description: team.description,
      avatar: team.avatar,
      inserted_at: team.inserted_at,
      updated_at: team.updated_at
    }
  end
end
