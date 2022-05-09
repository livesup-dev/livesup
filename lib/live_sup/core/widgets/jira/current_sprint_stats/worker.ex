defmodule LiveSup.Core.Widgets.Jira.CurrentSprintStats.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Jira.CurrentSprintStats.Handler

  @default_title "Current Sprint Stats"

  @impl true
  @spec public_settings :: []
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["board_id", "token", "domain"]

  @impl true
  def build_data(_settings, _user), do: {:error, :not_implemented}

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
