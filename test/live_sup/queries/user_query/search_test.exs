defmodule LiveSup.Tests.Queries.UserQuery.SearchTest do
  use ExUnit.Case, async: false
  use LiveSup.DataCase

  alias LiveSup.Queries.UserQuery
  alias LiveSup.Core.{Teams, Users}
  alias LiveSup.Test.AccountsFixtures

  setup [:setup_users]

  describe "search" do
    @describetag :user_query_search

    test "by name" do
      found_users = UserQuery.search("peter")

      assert [
               %{
                 email: "peter@something.com",
                 first_name: "Peter",
                 last_name: "Pan"
               }
             ] = found_users
    end

    test "by email" do
      found_users = UserQuery.search("john@livesup.com")

      assert [
               %{
                 email: "john@livesup.com",
                 first_name: "John",
                 last_name: "Doe"
               }
             ] = found_users
    end

    test "by word" do
      found_users = UserQuery.search("something.com")

      assert [
               %{
                 email: "peter@something.com",
                 first_name: "Peter",
                 last_name: "Pan"
               },
               %{
                 email: "paul@something.com",
                 first_name: "Paul",
                 last_name: "Pan"
               }
             ] = found_users
    end

    test "not in team" do
      {:ok, team_member} = setup_user_with_team()
      found_users = UserQuery.search(%{value: "something.com", not_in_team: team_member.team_id})

      [
        %{
          email: "peter@something.com",
          first_name: "Peter",
          last_name: "Pan"
        },
        %{
          email: "paul@something.com",
          first_name: "Paul",
          last_name: "Pan"
        }
      ] = found_users
    end
  end

  def setup_user_with_team() do
    user =
      %{
        email: "team@something.com",
        first_name: "Peter",
        last_name: "Team"
      }
      |> AccountsFixtures.user_fixture()

    {:ok, team} =
      %{
        name: "My Team"
      }
      |> Teams.create()

    {:ok, second_team} =
      %{
        name: "My Second Team"
      }
      |> Teams.create()

    Teams.add_member(team, user)
    Teams.add_member(second_team, user)
  end

  def setup_users(context) do
    Users.delete_all()

    [
      %{
        email: "john@livesup.com",
        first_name: "John",
        last_name: "Doe"
      },
      %{
        email: "peter@something.com",
        first_name: "Peter",
        last_name: "Pan"
      },
      %{
        email: "paul@something.com",
        first_name: "Paul",
        last_name: "Pan"
      }
    ]
    |> Enum.each(fn user ->
      AccountsFixtures.user_fixture(user)
    end)

    context
  end
end
