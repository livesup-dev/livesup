defmodule LiveSup.Core.Users do
  alias LiveSup.Queries.UserQuery

  defdelegate all(), to: UserQuery
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
end
