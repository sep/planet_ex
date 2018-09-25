use Mix.Config

config :planetex, PlanetExWeb.Endpoint,
  http: [port: 4001],
  server: true

config :planetex, :sql_sandbox, true

config :wallaby, chrome: [headless: true]

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :planetex, PlanetEx.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "planet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 999_999

config :planetex, :fetcher, FetchMock
config :planetex, :server_farm_supervisor, nil
