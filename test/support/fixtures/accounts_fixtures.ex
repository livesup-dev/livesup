defmodule LiveSup.Test.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveSup.Core.Accounts` context.
  """

  alias LiveSup.Schemas.User

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def default_bot_fixture(attrs \\ %{}) do
    email = unique_user_email()

    user_attrs =
      attrs
      |> Enum.into(%{
        email: email,
        password: valid_user_password(),
        first_name: "LiveSup",
        last_name: "Bot",
        location: %{},
        settings: %{},
        system: true,
        system_identifier: User.default_bot_identifier()
      })

    {:ok, user} =
      %LiveSup.Schemas.User{}
      |> LiveSup.Schemas.User.registration_changeset(user_attrs)
      |> LiveSup.Repo.insert()

    user
  end

  def user_fixture(attrs \\ %{}) do
    email = unique_user_email()

    user_attrs =
      attrs
      |> Enum.into(%{
        email: email,
        password: valid_user_password(),
        first_name: "John",
        last_name: "Doe",
        location: %{},
        settings: %{}
      })

    {:ok, user} =
      %LiveSup.Schemas.User{}
      |> LiveSup.Schemas.User.registration_changeset(user_attrs)
      |> LiveSup.Repo.insert()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
