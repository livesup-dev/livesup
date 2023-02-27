defmodule LiveSup.Core.Users do
  alias LiveSup.Queries.UserQuery
  alias LiveSup.Schemas.User

  defdelegate all(), to: UserQuery
  defdelegate delete_all(), to: UserQuery
  defdelegate search(query), to: UserQuery
  defdelegate get!(id), to: UserQuery
  defdelegate get(id), to: UserQuery
  defdelegate create(atts), to: UserQuery
  defdelegate create!(atts), to: UserQuery
  defdelegate delete(id), to: UserQuery
  defdelegate update(user, attrs), to: UserQuery
  defdelegate update!(user, attrs), to: UserQuery
  defdelegate onboard!(user), to: UserQuery
  defdelegate create_with_id(attrs), to: UserQuery

  defdelegate get_system_account!(identifier), to: UserQuery
  defdelegate get_system_account(identifier), to: UserQuery

  def get_default_system_account! do
    get_system_account!(User.default_bot_identifier())
  end
end
