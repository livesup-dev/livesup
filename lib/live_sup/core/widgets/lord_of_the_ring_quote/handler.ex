defmodule LiveSup.Core.Widgets.LordOfTheRingQuote.Handler do
  import Logger

  def get_data() do
    debug("LordOfTheRingQuote.Handler: get_data")

    {:ok, LiveSup.Core.Datasources.LordOfTheRingDatasource.get_quote()}
  end
end
