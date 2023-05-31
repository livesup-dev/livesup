defmodule LiveSup.Core.Widgets.MergeStat.TimeToMerge.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.MergeStat.TimeToMerge.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Time to merge by repo"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["repos"]

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
