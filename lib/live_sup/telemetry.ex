defmodule LiveSup.Telemetry do
  defmodule Events do
    def app_init(), do: [:live_sup, :init, :info]
    def widget_init(), do: [:live_sup, :widget, :init, :info]
    def widget_init_for_user(), do: [:live_sup, :widget, :init_for_user, :info]
    def widget_build_data(), do: [:live_sup, :widget, :build_data]
    def widget_build_data_stop(), do: [:live_sup, :widget, :build_data, :stop]
  end

  def init() do
    Events.app_init()
    |> execute(
      %{
        system_time: System.system_time()
      },
      %{}
    )
  end

  @doc false
  def execute(event_name, measurements, meta) do
    :telemetry.execute(event_name, measurements, meta)
  end
end
