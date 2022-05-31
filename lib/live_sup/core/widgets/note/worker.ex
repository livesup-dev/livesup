defmodule LiveSup.Core.Widgets.Note.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Note.Handler

  @default_title "Notes"

  @impl true
  def public_settings, do: []

  @impl true
  def settings_keys, do: ["note"]

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
