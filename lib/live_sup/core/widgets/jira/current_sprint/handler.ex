defmodule LiveSup.Core.Widgets.Jira.CurrentSprint.Handler do
  alias LiveSup.Core.Datasources.JiraDatasource

  def get_data(%{"board_id" => board_id, "token" => token, "domain" => domain}) do
    JiraDatasource.get_current_sprint(board_id, token: token, domain: domain)
  end
end
