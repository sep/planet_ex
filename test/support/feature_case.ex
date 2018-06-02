defmodule PlanetWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Planet.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import PlanetWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Planet.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Planet.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Planet.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    session = Wallaby.Browser.resize_window(session, 1024, 1024)
    {:ok, session: session}
  end
end
