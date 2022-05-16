# This widget is used for testing purpose only
defmodule LiveSup.Core.Widgets.LordOfTheRingQuote.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.LordOfTheRingQuote.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Lord of the Ring"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: []

  @impl true
  def build_data(_settings, _context) do
    Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
