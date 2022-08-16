defmodule LiveSupWeb.Api.TeamView do
  use LiveSupWeb, :view
  alias LiveSupWeb.Api.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      slug: team.slug,
      description: team.description,
      avatar_url: team.avatar_url,
      inserted_at: team.inserted_at,
      updated_at: team.updated_at
    }
  end
end
