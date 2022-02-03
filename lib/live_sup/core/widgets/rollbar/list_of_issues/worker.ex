defmodule LiveSup.Core.Widgets.Rollbar.ListOfIssues.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Rollbar.ListOfIssues.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Rollbar issues"

  def settings_keys, do: ["env", "limit", "status", "token"]

  @impl true
  def build_data(settings) do
    settings
    |> Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
