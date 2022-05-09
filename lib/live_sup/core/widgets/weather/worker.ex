defmodule LiveSup.Core.Widgets.Weather.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Weather.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Weather"

  @impl true
  def public_settings, do: ["team"]

  @impl true
  def settings_keys, do: ["key", "location"]

  @impl true
  def build_data(settings, _user), do: build_data(settings)

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
