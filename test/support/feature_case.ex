defmodule PlanetExWeb.FeatureCase do
  @moduledoc """
  This module sets up Feature tests using Wallaby and Google Chrome. 
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias PlanetEx.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Mox

      import PlanetExWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PlanetEx.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PlanetEx.Repo, {:shared, self()})
    end

    Mox.set_mox_global()

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(PlanetEx.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    session = Wallaby.Browser.resize_window(session, 1024, 1024)
    {:ok, session: session}
  end
end
