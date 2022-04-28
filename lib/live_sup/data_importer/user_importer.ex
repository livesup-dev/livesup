defmodule LiveSup.DataImporter.UserImporter do
  alias LiveSup.Core.{Users, Teams}
  alias LiveSup.Schemas.User

  def import(%{"users" => users} = data) do
    users
    |> Enum.each(fn user_attrs ->
      user_attrs
      |> Map.put("password", :crypto.strong_rand_bytes(16))
      |> get_or_create_user()
      |> add_teams(user_attrs)
    end)

    data
  end

  def import(data), do: data

  defp get_or_create_user(%{"id" => id} = attrs) do
    IO.inspect(attrs, label: :import)

    with {:ok, user} <- Users.get(id) do
      IO.inspect(user, label: :import)
      {:ok, user}
    else
      nil ->
        IO.inspect("not found", label: :import)
        Users.create(attrs)
    end
  end

  defp add_teams({:ok, %User{} = user}, %{"teams" => teams}) do
    teams
    |> Enum.each(fn team_attrs ->
      team = Teams.get_by_slug!(team_attrs["slug"])
      Teams.upsert_member(team, user)
    end)
  end
end
