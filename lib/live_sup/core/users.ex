defmodule LiveSup.Core.Users do
  alias LiveSup.Schemas.User
  alias LiveSup.Queries.UserQuery

  defdelegate all(), to: UserQuery
  defdelegate search(query), to: UserQuery
end
