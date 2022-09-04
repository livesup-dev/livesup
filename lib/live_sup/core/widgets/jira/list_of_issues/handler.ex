defmodule LiveSup.Core.Widgets.Jira.ListOfIssues.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource
  alias LiveSup.Core.Links

  def get_data(%{"token" => token, "domain" => domain, "statuses" => statuses}, %{
        widget_instance: %{datasource_instance: datasource_instance},
        user: user
      }) do
    case user |> Links.get_jira_link(datasource_instance) do
      {:ok, jira_schema} ->
        statuses_line = statuses |> build_statuses()

        "assignee = #{jira_schema.account_id} AND (#{statuses_line}) OR (updated > -3d AND assignee = #{jira_schema.account_id}) order by status"
        |> JiraDatasource.search_tickets(token: token, domain: domain)

      {:error, message} ->
        {:error, message}
    end
  end

  defp build_statuses(statuses) do
    statuses
    |> Enum.map_join(" OR ", fn status ->
      "status = '#{status}'"
    end)
  end
end
