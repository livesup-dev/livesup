# This widget is used for testing purpose only
defmodule LiveSup.Core.Widgets.LordOfTheRingQuote.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.LordOfTheRingQuote.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Lord of the Ring"

  def settings_keys, do: []

  @impl true
  def build_data(_settings) do
    Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
