defmodule LiveSup.Tests.Queries.UserQueryTest do
  use ExUnit.Case, async: true
  use LiveSup.DataCase

  alias LiveSup.Queries.UserQuery
  alias LiveSup.Test.AccountsFixtures

  setup [:setup_users]

  describe "managing users queries" do
    @describetag :user_query

    test "return all" do
      all_users = UserQuery.all()

      assert length(all_users) == 3
    end
  end

  def setup_users(context) do
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
