defmodule LiveSup do
  @moduledoc """
  Sup keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def config_runtime do
    import Config

    config :live_sup, LiveSupWeb.Endpoint,
      secret_key_base:
        LiveSup.Config.secret!("LIVESUP_SECRET_KEY_BASE") ||
          Base.encode64(:crypto.strong_rand_bytes(48))

    if port = LiveSup.Config.port!("LIVESUP_HTTP_PORT") do
      config :live_sup, LiveSupWeb.Endpoint, http: [port: port]
    end

    if hostname = LiveSup.Config.hostname!("LIVESUP_HOSTNAME") do
      config :live_sup, LiveSupWeb.Endpoint, url: [host: hostname]
    end

    if ip = LiveSup.Config.ip!("LIVESUP_IP") do
      config :live_sup, LiveSupWeb.Endpoint, http: [ip: ip]
    end

    if ssl = LiveSup.Config.db_ssl!("LIVESUP_DATABASE_SSL") do
      config :live_sup, LiveSup.Repo, ssl: ssl
    end

    if not LiveSup.Config.otel_enabled!("OTEL_ENABLED") do
      config :opentelemetry,
        traces_exporter: :none

      config :opentelemetry, :processors, [
        {:otel_simple_processor, %{}}
      ]
    end

    if openai_api_key = System.get_env("OPENAI_API_KEY") do
      config :openai,
        # find it at https://platform.openai.com/account/api-keys
        api_key: openai_api_key,
        # find it at https://platform.openai.com/account/org-settings under "Organization ID"
        organization_key: System.get_env("OPENAI_ORGANIZATION_ID"),
        # optional, passed to [HTTPoison.Request](https://hexdocs.pm/httpoison/HTTPoison.Request.html) options
        http_options: [recv_timeout: 30_000],
        # optional, useful if you want to do local integration tests using Bypass or similar
        # (https://github.com/PSPDFKit-labs/bypass), do not use it for production code,
        # but only in your test config!
        api_url: System.get_env("OPENAI_API_URL") || "http://localhost/"
    end
  end
end
