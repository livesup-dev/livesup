defmodule LiveSup.Core.Widgets.ChuckNorrisJoke.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.ChuckNorrisJoke.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Chuck Norris's jokes"

  @impl true
  def settings_keys, do: []

  @impl true
  def public_settings, do: []

  @impl true
  def build_data(_settings, _user), do: {:error, :not_implemented}

  @impl true
  def build_data(_settings) do
    Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
