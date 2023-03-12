import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :live_sup, LiveSup.Repo,
  username: "postgres",
  password: "postgres",
  database: "sup_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  migration_lock: nil,
  queue_target: 5000

config :live_sup, LiveSupWeb.Api.Guardian,
  issuer: "livesup",
  secret_key: "test_secret"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_sup, LiveSupWeb.Endpoint,
  http: [port: 4002],
  server: false

config :bypass, enable_debug_log: true

# Print only warnings and errors during test
config :logger, level: :warn

config :live_sup, LiveSup.PromEx,
  disabled: true,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: :disabled,
  metrics_server: :disabled

config :live_sup, Oban, testing: :inline
