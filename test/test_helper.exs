ExUnit.configure(timeout: :infinity, exclude: [feature: true])
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(PlanetEx.Repo, :manual)
Application.put_env(:wallaby, :base_url, PlanetExWeb.Endpoint.url())

{:ok, _} = Application.ensure_all_started(:wallaby)
