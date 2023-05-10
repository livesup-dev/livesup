defmodule LiveSup.DataImporter.TeamImporter do
  alias LiveSup.Core.{Teams, Users}

  def perform(data) when is_binary(data) do
    data
    |> LiveSup.DataImporter.Importer.parse_yaml()
    |> perform()
  end

  def perform(%{"teams" => teams} = data) do
    teams
    |> Enum.each(fn team_attrs ->
      team_attrs
      |> get_or_create_team()
    end)

    data
  end

  def perform(data) when is_map(data), do: data

  defp get_or_create_team(attrs) do
    case Teams.upsert(attrs) do
      {:ok, team} ->
        team
        |> manage_team_members(attrs)

      {:error, _changeset} ->
        raise "Error creating team #{inspect(attrs)}"
    end
  end

  defp manage_team_members(team, %{"members" => members}) do
    members
    |> Enum.each(fn member_attrs ->
      user =
        case Users.get(member_attrs["id"]) do
          nil ->
            {:ok, user} = Users.upsert(member_attrs |> set_random_password())
            user

          user ->
            user
        end

      case Teams.member?(team, user) do
        true -> :ok
        false -> Teams.add_member(team, user)
      end
    end)
  end

  defp manage_team_members(team, _attrs), do: team

  defp set_random_password(%{"password" => _} = attrs), do: attrs
  defp set_random_password(attrs), do: Map.put(attrs, "password", :crypto.strong_rand_bytes(16))
end
