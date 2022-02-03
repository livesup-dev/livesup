defmodule Mix.Tasks.LiveSup.MockApi.Enable do
  @moduledoc "Change datasources to read from the MockApi"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start", [])
    LiveSup.Helpers.FeatureManager.enable_mock_api()
  end
end
