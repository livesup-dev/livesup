defmodule LiveSup.Core.Widgets.Blameless.LastIncidents.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Blameless.LastIncidents.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Last incidents"

  @impl true
  def settings_keys, do: ["client_id", "client_secret", "audience", "endpoint", "limit"]

  @impl true
  def public_settings, do: []

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
