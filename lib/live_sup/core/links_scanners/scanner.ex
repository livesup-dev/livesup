defmodule LiveSup.Core.LinksScanners.Scanner do
  alias LiveSup.Core.LinksScanners.JiraScanner
  alias LiveSup.Schemas.User
  alias LiveSup.Queries.UserQuery

  def scan(%User{} = user, datasource) do
    case datasource do
      "jira" -> user |> JiraScanner.scan()
    end
  end

  def scan(user_id, datasource) do
    user_id
    |> UserQuery.get!()
    |> scan(datasource)
  end
end
