defmodule LiveSup.Core.Widgets.Jira.ListOfEpics.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource

  def get_data(%{
        "token" => token,
        "domain" => domain,
        "project" => project,
        "component" => component
      }) do
    JiraDatasource.epic_issues(project, component, token: token, domain: domain)
  end
end
