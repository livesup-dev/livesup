defmodule LiveSup.Core.Widgets.Blameless.IncidentsByDate.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Blameless.IncidentsByDate.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Incidents by date"

  @impl true
  def settings_keys, do: ["client_id", "client_secret", "audience", "limit", "endpoint"]

  @impl true
  def public_settings, do: []

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
