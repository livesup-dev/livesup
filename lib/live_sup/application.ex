defmodule LiveSup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      LiveSup.PromEx,
      # Start the Ecto repository
      LiveSup.Repo,
      # Start the Telemetry supervisor
      LiveSupWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveSup.PubSub},
      # Start the Endpoint (http/https)
      LiveSupWeb.Endpoint,
      {Task.Supervisor, name: LiveSup.Core.Widgets.WorkerTaskSupervisor},
      {LiveSup.Core.Widgets.WidgetSupervisor, [name: :widget_supervisor]},
      {Oban, Application.fetch_env!(:live_sup, Oban)}

      # Start a worker by calling: LiveSup.Worker.start_link(arg)
      # {LiveSup.Worker, arg}
    ]

    services = [
      {Finch, name: SupFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveSup.Supervisor]
    Supervisor.start_link(children ++ services, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveSupWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
