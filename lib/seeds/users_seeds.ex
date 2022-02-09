defmodule LiveSup.Seeds.UsersSeeds do
  alias LiveSup.Repo
  alias LiveSup.Schemas.{User, UserGroup}
  alias LiveSup.Queries.GroupQuery
  alias LiveSup.Core.Accounts

  def seed, do: insert_data()

  defp insert_data do
    administrators_group = GroupQuery.get_administrator_group()
    all_users_group = GroupQuery.get_all_users_group()

    [
      %{
        user: %{
          first_name: "Emiliano",
          last_name: "Jankowski",
          avatar_url:
            "https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/5a390ef9280a8d389404eebe/53550071-f045-44f3-bc75-96956f8541c3/48",
          email: "emiliano@summing-up.com",
          password: "Very@Safe@Password",
          location: User.default_location()
        }
      },
      %{
        user: %{
          first_name: "John",
          last_name: "Doe",
          avatar_url: nil,
          email: "john@summing-up.com",
          password: "Very@Safe@Password",
          location: %{
            "timezone" => "America/New_York",
            "city" => "New York",
            "state" => "New York",
            "country" => "United States",
            "zip_code" => "07720"
          }
        }
      }
    ]
    |> Enum.map(fn data ->
      user = Accounts.get_user_by_email(data[:user][:email]) || insert_user(data[:user])

      UserGroup.changeset(%UserGroup{}, %{user_id: user.id, group_id: administrators_group.id})
      |> Repo.insert!(on_conflict: :nothing)

      UserGroup.changeset(%UserGroup{}, %{user_id: user.id, group_id: all_users_group.id})
      |> Repo.insert!(on_conflict: :nothing)
    end)
  end

  defp insert_user(data) do
    User.registration_changeset(%User{}, data)
    |> Repo.insert!(on_conflict: :nothing)
  end
end
