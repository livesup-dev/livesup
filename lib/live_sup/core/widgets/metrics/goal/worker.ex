defmodule LiveSup.Core.Widgets.Metrics.Goal.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Metrics.Goal.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Goal"

  def settings_keys, do: ["metric"]

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
