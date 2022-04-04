defmodule LiveSup.Core.Teams do
  alias LiveSup.Repo

  @moduledoc """
  The Projects context.
  """

  alias LiveSup.Schemas.{Team, User, TeamMember}
  alias LiveSup.Queries.TeamQuery

  @doc """
  Returns the list of teams.

  ## Examples

      iex> all()
      [%Project{}, ...]

  """
  defdelegate all(), to: TeamQuery
  defdelegate all(project), to: TeamQuery
  defdelegate get(id), to: TeamQuery
  defdelegate get!(id), to: TeamQuery
  defdelegate get_by_slug!(slug), to: TeamQuery
  defdelegate get_by_slug(slug), to: TeamQuery
  defdelegate create(attrs), to: TeamQuery
  defdelegate create!(attrs), to: TeamQuery
  defdelegate update(team, attrs), to: TeamQuery
  defdelegate update!(team, attrs), to: TeamQuery
  defdelegate delete(team), to: TeamQuery
  defdelegate delete_members(team), to: TeamQuery
  defdelegate members(team), to: TeamQuery
  defdelegate upsert(attrs), to: TeamQuery

  def change(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end

  def add_member(%Team{} = team, %User{} = user) do
    TeamMember.changeset(%TeamMember{}, %{team_id: team.id, user_id: user.id})
    |> Repo.insert()
  end
end
