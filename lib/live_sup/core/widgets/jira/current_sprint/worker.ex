defmodule LiveSup.Core.Widgets.Jira.CurrentSprint.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Jira.CurrentSprint.Handler

  @default_title "Jira Current Sprint"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["board_id", "token", "domain"]

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
