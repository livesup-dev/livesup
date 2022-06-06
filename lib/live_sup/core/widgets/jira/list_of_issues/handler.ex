defmodule LiveSup.Core.Widgets.Jira.ListOfIssues.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource
  alias LiveSup.Core.Links

  def get_data(%{"token" => token, "domain" => domain, "statuses" => statuses}, %{
        widget_instance: %{datasource_instance: datasource_instance},
        user: user
      }) do
    with {:ok, jira_schema} <- user |> Links.get_jira_link(datasource_instance) do
      statuses_line = statuses |> build_statuses()

      "assignee = #{jira_schema.account_id} AND (#{statuses_line}) OR (updated > -3d AND assignee = #{jira_schema.account_id}) order by status"
      |> JiraDatasource.search_tickets(token: token, domain: domain)
    else
      {:error, message} ->
        {:error, message}
    end
  end

  defp build_statuses(statuses) do
    statuses
    |> Enum.map(fn status ->
      "status = '#{status}'"
    end)
    |> Enum.join(" OR ")
  end
end
