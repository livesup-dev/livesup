defmodule LiveSup.Core.Widgets.PagerDuty.OnCall.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.PagerDuty.OnCall.Handler

  @default_title "On Call"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["schedule_ids", "token"]

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
