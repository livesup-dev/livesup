defmodule LiveSup.Core.Widgets.WidgetSupervisor do
  use Supervisor

  alias LiveSup.Core.Widgets.{WidgetManager, WidgetRegistry}

  def start_link(args) do
    Supervisor.start_link(__MODULE__, %{}, args)
  end

  @impl true
  def init(_args) do
    LiveSup.Telemetry.init()

    # :one_for_one - if a child process terminates, only that process is restarted.
    children = [
      {Registry, [name: WidgetRegistry.name(), keys: :unique]},
      {DynamicSupervisor, [name: WidgetManager.name(), strategy: :one_for_one]}
    ]

    # :rest_for_one - if a child process terminates,
    # the terminated child process and the rest of the children started after it,
    # are terminated and restarted.
    Supervisor.init(children, strategy: :rest_for_one)
  end
end
