defmodule LiveSup.Core.Widgets.Jira.ListOfIssues.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Jira.ListOfIssues.Handler

  @default_title "Your Jira issues"

  @impl true
  def public_settings, do: ["domain"]

  @impl true
  def settings_keys, do: ["token", "domain", "statuses"]

  @impl true
  def build_data(settings, context) do
    settings
    |> Handler.get_data(context)
  end

  @impl true
  def default_title() do
    @default_title
  end
end
