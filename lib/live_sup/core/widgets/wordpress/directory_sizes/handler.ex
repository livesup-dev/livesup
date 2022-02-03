defmodule LiveSup.Core.Widgets.Wordpress.DirectorySizes.Handler do
  alias LiveSup.Core.Datasources.WordpressDatasource
  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig
  import Logger

  def get_data(%WordpressConfig{url: url} = config) do
    debug("Handler: #{url}")

    config
    |> WordpressDatasource.directory_sizes()
  end
end
