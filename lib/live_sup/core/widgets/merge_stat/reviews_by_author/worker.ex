defmodule LiveSup.Core.Widgets.MergeStat.ReviewsByAuthor.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.MergeStat.ReviewsByAuthor.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Reviews by Author"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["repo", "limit", "url"]

  @impl true
  def build_data(settings, context) do
    settings
    |> Handler.get_data(context)
  end

  @impl true
  def default_title() do
    @default_title
  end
end
