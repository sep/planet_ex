defmodule PlanetEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :planetex,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      preferred_cli_env: [
        "test.all": :test,
        "test.feature": :test,
        verify: :test
      ],
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PlanetEx.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:distillery, "~> 2.0"},
      {:dotenv, "~> 2.0.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:httpoison, "~> 1.0", override: true},
      {:mox, "~> 0.3.2", only: :test},
      {:phoenix, "~> 1.3.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:sweet_xml, git: "git@github.com:mhanberg/sweet_xml.git"},
      {:timex, "~> 3.0"},
      {:wallaby, "~> 0.20.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "assets.compile --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ],
      "test.feature": "test --only feature",
      "test.all": "test --include feature",
      "assets.compile": &compile_assets/1,
      verify: [
        "format --check-formatted",
        "credo",
        "test.all"
      ]
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd("assets/node_modules/brunch/bin/brunch build assets/")
  end
end
