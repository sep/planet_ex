defmodule Planet.Application do
  @moduledoc false
  @server_farm_supervisor Application.get_env(:planet, :server_farm_supervisor)

  use Application

  def start(_type, _args) do
    children =
      Enum.filter(
        [
          Planet.Repo,
          PlanetWeb.Endpoint,
          @server_farm_supervisor
        ],
        & &1
      )

    opts = [strategy: :one_for_one, name: Planet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PlanetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
