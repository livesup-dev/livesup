defmodule LiveSup.Core.Widgets.WidgetLogger do
  defmacro __using__(_) do
    quote do
      require Logger

      def debug(message) do
        Logger.debug("#{__MODULE__}.#{message}")
      end
    end
  end
end
