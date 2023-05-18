defmodule LiveSup.Core.Widgets.Todo.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Todo.Handler
  alias LiveSup.Schemas.WidgetInstance

  @default_title "Todo"

  @impl true
  def public_settings, do: ["todo"]

  @impl true
  def settings_keys, do: ["todo"]

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
