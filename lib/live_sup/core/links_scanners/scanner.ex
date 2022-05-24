defmodule LiveSup.Core.LinksScanners.Scanner do
  alias LiveSup.Core.LinksScanners.JiraScanner
  alias LiveSup.Schemas.User

  def scan(%User{} = user, datasource) do
    case datasource do
      "jira" -> user |> JiraScanner.scan()
    end
  end

  def scan(user_id, datasource) do
    %User{id: user_id}
    |> scan(datasource)
  end
end
