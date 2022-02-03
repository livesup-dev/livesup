defmodule LiveSup.Core.Widgets.ChuckNorrisJoke.Handler do
  alias LiveSup.Core.Datasources.ChuckNorrisApiDatasource

  def get_data() do
    ChuckNorrisApiDatasource.get_joke()
  end
end
