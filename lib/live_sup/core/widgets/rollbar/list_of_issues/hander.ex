defmodule LiveSup.Core.Widgets.Rollbar.ListOfIssues.Handler do
  alias LiveSup.Core.Datasources.RollbarDatasource

  def get_data(%{"env" => _, "limit" => _, "status" => _, "token" => token} = args) do
    args
    |> Map.drop(["token"])
    |> RollbarDatasource.get_issues(token: token)
  end

  @spec get_data(map, [{:url, any}, ...]) :: {:error, any} | {:ok, list}
  def get_data(%{"env" => _, "limit" => _, "status" => _, "token" => token} = args, url: url) do
    args
    |> Map.drop(["token"])
    |> RollbarDatasource.get_issues(token: token, url: url)
  end
end
