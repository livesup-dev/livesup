defmodule LiveSup.Core.Widgets.Blameless.IncidentsByDate.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Blameless.IncidentsByDate.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Incidents by date"

  def settings_keys, do: ["client_id", "client_secret", "audience", "limit", "endpoint"]

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
