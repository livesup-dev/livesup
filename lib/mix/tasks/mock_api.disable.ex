defmodule Mix.Tasks.LiveSup.MockApi.Disable do
  @moduledoc "Change datasources to read from the MockApi"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start", [])
    LiveSup.Helpers.FeatureManager.disable_mock_api()
  end
end
