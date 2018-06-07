defmodule Planet.Application do
  use Application

  def start(_type, _args) do
    children = [
      Planet.Repo,
      PlanetWeb.Endpoint,
      Planet.Core.FeedServer
    ]

    opts = [strategy: :one_for_one, name: Planet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PlanetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
