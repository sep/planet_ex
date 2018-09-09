use Mix.Config

config :planet, PlanetWeb.Endpoint,
  http: [port: 4001],
  server: true

config :planet, :sql_sandbox, true

config :wallaby, chrome: [headless: true]

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :planet, Planet.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "planet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 999_999

config :planet, :fetcher, FetchMock
config :planet, :server_farm_supervisor, nil
