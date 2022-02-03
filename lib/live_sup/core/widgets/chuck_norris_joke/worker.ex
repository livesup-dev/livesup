defmodule LiveSup.Core.Widgets.ChuckNorrisJoke.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.ChuckNorrisJoke.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Chuck Norris's jokes"

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
