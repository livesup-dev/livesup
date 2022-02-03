defmodule LiveSup.Core.Widgets.Wordpress.DirectorySizes.Worker do
  use LiveSup.Core.Widgets.WidgetServer

  alias LiveSup.Core.Widgets.Wordpress.DirectorySizes.Handler
  alias LiveSup.Schemas.WidgetInstance
  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig

  @default_title "Wordpress directory sizes"

  def settings_keys, do: WordpressConfig.keys()

  @impl true
  def build_data(settings) do
    settings
    |> WordpressConfig.build()
    |> Handler.get_data()
  end

  @impl true
  def default_title() do
    @default_title
  end
end
