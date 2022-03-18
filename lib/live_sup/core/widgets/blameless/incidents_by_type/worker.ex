defmodule LiveSup.Core.Widgets.Blameless.IncidentsByType.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Blameless.IncidentsByType.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Incidents by type"

  @impl true
  def settings_keys, do: ["client_id", "client_secret", "audience", "limit", "endpoint"]

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
