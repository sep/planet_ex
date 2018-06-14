use Mix.Config

config :planet, PlanetWeb.Endpoint,
  http: [port: 4001],
  server: true

config :planet, :sql_sandbox, true

config :wallaby,
  screenshot_on_failure: true,
  driver: Wallaby.Experimental.Chrome

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :planet, Planet.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "planet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :planet, :fetcher, FetchMock
config :planet, :feed_server, []
config :planet, :server_timeout, 1
