defmodule LiveSup.DataImporter.UserImporter do
  alias LiveSup.Core.{Users, Teams, Groups}
  alias LiveSup.Schemas.User
  alias LiveSup.Queries.GroupQuery

  def perform(%{"users" => users} = data) do
    all_users_group = GroupQuery.get_all_users_group()

    users
    |> Enum.each(fn user_attrs ->
      password = Map.get(user_attrs, "password", :crypto.strong_rand_bytes(16))

      user_attrs
      |> Map.put("password", password)
      |> get_or_create_user()
      |> add_to_group(all_users_group)
      |> find_links()
    end)

    data
  end

  def perform(data), do: data

  defp get_or_create_user(%{"id" => id} = attrs) do
    case Users.get(id) do
      {:ok, user} -> {:ok, user}
      nil -> Users.create(attrs)
    end
  end

  # defp add_teams({:ok, %User{} = user}, %{"teams" => teams}) do
  #   teams
  #   |> Enum.each(fn team_attrs ->
  #     team = Teams.get_by_slug!(team_attrs["slug"])
  #     Teams.upsert_member(team, user)
  #   end)
  # end

  defp find_links({:ok, %User{} = user}) do
    LiveSup.Core.LinksScanners.Scanner.scan(user, "jira-datasource")

    {:ok, user}
  end

  defp add_to_group({:ok, %User{} = user}, group) do
    Groups.add_user(user, group)

    {:ok, user}
  end
end
