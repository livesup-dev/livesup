defmodule LiveSup.Core.Widgets.TeamMembers.Handler do
  alias LiveSup.Core.Teams
  alias LiveSup.Schemas.User

  def get_data(%{"team" => team_id}) do
    # TODO: We need to cache this query
    team_id
    |> Teams.users()
    |> build_times()
  end

  defp build_times(nil), do: {:ok, []}

  defp build_times(users) do
    data =
      users
      |> Enum.map(fn user ->
        now = DateTime.now!(user.location["timezone"])

        %{
          full_name: User.full_name(user),
          avatar: User.default_avatar_url(user),
          # TODO: make some calculation to know if it is working hour or not
          night: is_night?(now),
          email: user.email,
          datetime: now,
          now_str: Calendar.strftime(now, "%I:%M %p"),
          address: User.address(user)
        }
      end)

    {:ok, data}
  end

  defp is_night?(now) do
    hour = now.hour

    if (hour >= 0 && hour <= 7) || (hour >= 19 && hour <= 23) do
      true
    else
      false
    end
  end
end
