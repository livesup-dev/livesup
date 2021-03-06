defmodule LiveSup.Core.Widgets.Datadog.Scalar.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Datadog.Scalar.Handler

  @default_title "Datadog scalar"

  @impl true
  def settings_keys, do: ["query", "n_days", "api_key", "application_key", "target", "unit"]

  @impl true
  def public_settings, do: ["n_days", "target", "unit"]

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
