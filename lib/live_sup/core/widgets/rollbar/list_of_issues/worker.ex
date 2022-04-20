defmodule LiveSup.Core.Widgets.Rollbar.ListOfIssues.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Rollbar.ListOfIssues.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Rollbar issues"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["env", "limit", "status", "token", "item_prefix"]

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
