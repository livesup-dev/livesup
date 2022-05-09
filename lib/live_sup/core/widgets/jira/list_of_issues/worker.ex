defmodule LiveSup.Core.Widgets.Jira.ListOfIssues.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Jira.ListOfIssues.Handler

  @default_title "Your Jira issues"

  @impl true
  def public_settings, do: ["domain"]

  @impl true
  def settings_keys, do: ["token", "domain", "statuses"]

  @impl true
  def build_data(settings, user) do
    settings
    |> Handler.get_data(user)
  end

  @impl true
  def build_data(_settings), do: {:error, :not_implemented}

  @impl true
  def default_title() do
    @default_title
  end
end
