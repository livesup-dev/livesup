defmodule LiveSup.DataImporter.UserImporter do
  alias LiveSup.Core.{Users, Groups}
  alias LiveSup.Schemas.User
  alias LiveSup.Queries.GroupQuery
  alias LiveSup.DataImporter.Users.LinkImporter

  def perform(data) when is_binary(data) do
    data
    |> LiveSup.DataImporter.Importer.parse_yaml()
    |> perform()
  end

  def perform(%{"users" => users} = data) do
    all_users_group = GroupQuery.get_all_users_group()

    users
    |> Enum.each(fn user_attrs ->
      password = Map.get(user_attrs, "password", :crypto.strong_rand_bytes(16))

      {:ok, user} =
        user_attrs
        |> Map.put("password", password)
        |> get_or_create_user()
        |> create_default_personal_group()
        |> add_to_group(all_users_group)

      # |> find_links()

      user
      |> import_links(user_attrs)
    end)

    data
  end

  def perform(data), do: data

  defp get_or_create_user(%{"id" => id} = attrs) do
    case Users.get(id) do
      nil -> Users.create(attrs)
      user -> {:ok, user}
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
    LiveSup.Core.LinksScanners.Scanner.scan_all(user)

    {:ok, user}
  end

  defp import_links(user, %{"links" => links}) do
    LinkImporter.perform(user, links)

    {:ok, user}
  end

  defp import_links(user, _data), do: {:ok, user}

  defp create_default_personal_group({:ok, user}) do
    case Groups.user_default_group(user) do
      nil ->
        user
        |> Groups.create_user_default_group()

        {:ok, user}

      _ ->
        {:ok, user}
    end
  end

  defp add_to_group({:ok, %User{} = user}, group) do
    case Groups.member?(group, user) do
      false -> Groups.add_user(user, group)
      _ -> :ok
    end

    {:ok, user}
  end
end
