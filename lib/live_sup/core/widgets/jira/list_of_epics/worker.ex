defmodule LiveSup.Core.Widgets.Jira.ListOfEpics.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Jira.ListOfEpics.Handler

  @default_title "Epics for {component}"

  @impl true
  def public_settings, do: ["domain"]

  @impl true
  def settings_keys, do: ["token", "domain", "project", "component"]

  @impl true
  def build_data(settings, _context) do
    settings
    |> Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
