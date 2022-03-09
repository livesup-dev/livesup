# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :live_sup, ecto_repos: [LiveSup.Repo], generators: [binary_id: true]

# Configures the endpoint
config :live_sup, LiveSupWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: LiveSupWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveSup.PubSub,
  live_view: [signing_salt: "livesup_ygEB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :fun_with_flags, :cache,
  enabled: true,
  # in seconds
  ttl: 900

config :fun_with_flags, :cache_bust_notifications, enabled: true

config :fun_with_flags, :persistence,
  adapter: FunWithFlags.Store.Persistent.Ecto,
  repo: LiveSup.Repo

config :tentacat,
  pagination: :none

# FunWithFlags configuration
config :fun_with_flags, :cache_bust_notifications,
  enabled: true,
  adapter: FunWithFlags.Notifications.PhoenixPubSub,
  client: LiveSup.PubSub

config :live_sup, :config, mock_api_host: "http://docker.for.mac.localhost:8080"

config :live_sup, LiveSup.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: :disabled,
  metrics_server: :disabled

config :live_sup, LiveSupWeb.Api.Guardian,
      issuer: "livesup",
      secret_key: {System, :get_env, ["GUARDIAN_SECRET"]},
      ttl: {2, :days}

config :live_sup, LiveSupWeb.AuthAccessPipeline,
      module: Tutorial.Guardian,
      error_handler: TutorialWeb.AuthErrorHandler

config :ueberauth, Ueberauth,
  base_path: "/oauth",
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]},
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_OAUTH_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_OAUTH_CLIENT_SECRET"]}

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_OAUTH_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_OAUTH_CLIENT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
