defmodule LiveSup.Core.Widgets.LordOfTheRingQuote.Handler do
  def get_data() do
    {:ok, LiveSup.Core.Datasources.LordOfTheRingDatasource.get_quote()}
  end
end
