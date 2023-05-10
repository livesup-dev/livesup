defmodule LiveSup.Core.Widgets.Jira.CurrentSprintStats.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource

  def get_data(%{
        "board_id" => board_id,
        "token" => token,
        "domain" => domain
      }) do
    JiraDatasource.get_current_sprint_issues(board_id, token: token, domain: domain)
    |> parse_stats()
  end

  defp parse_stats({:error, _error} = args), do: args

  defp parse_stats({:ok, issues}) do
    data =
      issues
      |> Enum.group_by(& &1.status)
      |> Enum.map(fn groupped_issue ->
        {status, _} = groupped_issue
        count = count_issues_by_status(issues, status)

        %{
          status: status,
          count: count
        }
      end)
      |> Enum.filter(fn status ->
        status[:count] > 0
      end)

    {:ok, data}
  end

  defp count_issues_by_status(issues, status) do
    issues
    |> Enum.filter(fn issue -> issue[:status] == status end)
    |> Enum.count()
  end
end
