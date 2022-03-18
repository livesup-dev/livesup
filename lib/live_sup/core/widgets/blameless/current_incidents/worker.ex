defmodule LiveSup.Core.Widgets.Blameless.CurrentIncidents.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Blameless.CurrentIncidents.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Current incidents"

  @impl true
  def settings_keys, do: ["client_id", "client_secret", "audience", "endpoint"]

  @impl true
  def public_settings, do: []

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
