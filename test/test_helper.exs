ExUnit.configure(timeout: :infinity)
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Planet.Repo, :manual)
Application.put_env(:wallaby, :base_url, PlanetWeb.Endpoint.url())

{:ok, _} = Application.ensure_all_started(:wallaby)
