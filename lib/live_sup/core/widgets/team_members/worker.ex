defmodule LiveSup.Core.Widgets.TeamMembers.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.TeamMembers.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Team Members"

  @impl true
  def public_settings, do: ["team"]

  @impl true
  def settings_keys, do: ["team"]

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
