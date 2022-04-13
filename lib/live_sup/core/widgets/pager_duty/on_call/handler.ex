defmodule LiveSup.Core.Widgets.PagerDuty.OnCall.Handler do
  alias LiveSup.Core.Datasources.PagerDutyDatasource

  def get_data(%{"schedule_ids" => _schedule_ids, "token" => _token} = args) do
    args
    |> PagerDutyDatasource.get_on_call()
  end
end
