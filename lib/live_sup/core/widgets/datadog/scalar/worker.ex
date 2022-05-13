defmodule LiveSup.Core.Widgets.Datadog.Scalar.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Datadog.Scalar.Handler

  @default_title "Datadog scalar"

  @impl true
  def settings_keys, do: ["query", "n_days", "api_key", "application_key", "target", "unit"]

  @impl true
  def public_settings, do: ["n_days", "target", "unit"]

  @impl true
  def build_data(_settings, _user), do: {:error, :not_implemented}

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
