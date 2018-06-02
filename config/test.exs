use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
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
