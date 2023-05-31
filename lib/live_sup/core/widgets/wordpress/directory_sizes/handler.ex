defmodule LiveSup.Core.Widgets.Wordpress.DirectorySizes.Handler do
  alias LiveSup.Core.Datasources.WordpressDatasource
  alias LiveSup.Core.Widgets.Wordpress.WordpressConfig

  def get_data(%WordpressConfig{url: _url} = config) do
    config
    |> WordpressDatasource.directory_sizes()
  end
end
