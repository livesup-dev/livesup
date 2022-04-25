defmodule LiveSup.Core.Widgets.Jira.CurrentSprintStats.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource

  def get_data(%{
        "project" => project,
        "board_id" => board_id,
        "token" => token,
        "domain" => domain
      }) do
    {:ok, statuses} = JiraDatasource.get_project_status(project, %{token: token, domain: domain})

    JiraDatasource.get_current_sprint_issues(board_id, token: token, domain: domain)
    |> parse_stats(statuses)
  end

  defp parse_stats({:ok, issues}, statuses) do
    statuses
    |> Enum.map(fn status ->
      count = count_issues_by_status(issues, status)

      %{
        status: status,
        count: count
      }
    end)
    |> Enum.filter(fn status ->
      status[:count] > 0
    end)
  end

  defp count_issues_by_status(issues, status) do
    issues
    |> Enum.filter(fn issue -> issue[:status] == status end)
    |> Enum.count()
  end
end
