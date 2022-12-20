defmodule LiveSup.MixProject do
  use Mix.Project

  @elixir_requirement "~> 1.13"
  @version "0.0.4"
  @description "Add transparency to the services you use and it creates a layer that organizes and simplifies the information you need when you need it"

  def project do
    [
      app: :live_sup,
      name: "Livesup",
      version: @version,
      description: @description,
      elixir: @elixir_requirement,
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Docs
      source_url: "https://github.com/livesup-dev/livesup",
      homepage_url: "https://livesup.dev/",
      docs: [
        # The main page in the docs
        main: "LiveSup",
        logo: "assets/static/images/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LiveSup.Application, []},
      extra_applications: [:logger, :runtime_tools, :ssl]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test),
    do: ["lib", "test/support", "test/live_sup/core/datasources/data_helper"]

  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.18.0"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 3.1"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:timex, ">= 0.0.0"},
      {:elixir_feed_parser, ">= 0.0.0"},
      {:finch, "~> 0.8"},
      {:fun_with_flags, "~> 1.8.0"},
      {:tentacat, "~> 2.0"},
      {:bypass, "~> 2.1", only: :test},
      {:mock, "~> 0.3.0", only: :test},
      {:prom_ex, "~> 1.5.0"},
      {:yaml_elixir, "~> 2.8.0"},
      {:earmark, "~> 1.4"},

      # Additional packages
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:sobelow, "~> 0.8", only: :dev},
      {:ecto_psql_extras, "~> 0.2"},
      {:bodyguard, "~> 2.4"},
      {:ecto_autoslug_field, "~> 3.0"},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},

      # Auth
      {:guardian, "~> 2.0"},
      {:ueberauth, "~> 0.6"},
      {:ueberauth_google, "~> 0.10"},
      {:ueberauth_github, "~> 0.8"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ] ++ local_deps()
  end

  def local_deps() do
    palette_dep(File.exists?("../palette"))
  end

  def palette_dep(true = _local) do
    [{:palette, path: "../palette"}]
  end

  def palette_dep(false) do
    [
      {:palette, git: "https://github.com/livesup-dev/palette", tag: "0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      # , "run priv/repo/seeds.exs"
      "ecto.setup": ["ecto.create", "ecto.migrate", "live_sup.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup", "live_sup.seed"],
      "ecto.reset.db": ["ecto.drop", "ecto.create", "ecto.migrate"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
