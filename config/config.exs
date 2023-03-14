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

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.16.4",
  default: [
    args: ~w(js/app.js
      --bundle
      --target=es2017
      --outdir=../priv/static/assets
      --external:/fonts/*
      --external:/images/*
      --external:/js/*
      --external:/css/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

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

config :live_sup,
       :config,
       google_map_key: "GOOGLE_MAP_KEY"

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

config :live_sup, LiveSupWeb.Plugs.AuthAccessPipeline,
  module: LiveSupWeb.Api.Guardian,
  error_handler: LiveSupWeb.Plugs.AuthErrorHandler

config :ueberauth, Ueberauth,
  base_path: "/oauth",
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]},
    github: {Ueberauth.Strategy.Github, []},
    okta: {
      Ueberauth.Strategy.Okta,
      [
        oauth2_params: [
          scope: "openid email profile",
          audience: {System, :get_env, ["OKTA_AUDIENCE"]}
        ]
      ]
    }
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: {System, :get_env, ["GOOGLE_OAUTH_CLIENT_ID"]},
  client_secret: {System, :get_env, ["GOOGLE_OAUTH_CLIENT_SECRET"]}

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: {:system, "GITHUB_OAUTH_CLIENT_ID"},
  client_secret: {:system, "GITHUB_OAUTH_CLIENT_SECRET"}

config :live_sup, Oban,
  repo: LiveSup.Repo,
  plugins: [
    # prune jobs after 5 minutes
    {Oban.Plugins.Pruner, max_age: 300},
    {Oban.Plugins.Cron,
     crontab: [
       # Run job every minute
       {"*/5 * * * *", LiveSup.Workers.TodoDatasourceSupervisorWorker}
     ]}
  ],
  queues: [
    default: 10,
    todo_datasources: 10
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
