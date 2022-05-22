defmodule LiveSup.Core.Widgets.Metrics.Goal.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Metrics.Goal.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Goal"

  @impl true
  def public_settings, do: ["metric", "range_color_order"]

  @impl true
  def settings_keys, do: ["metric"]

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
