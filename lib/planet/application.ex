defmodule PlanetEx.Application do
  @moduledoc false
  @server_farm_supervisor Application.get_env(:planetex, :server_farm_supervisor)

  use Application

  def start(_type, _args) do
    children =
      Enum.filter(
        [
          PlanetEx.Repo,
          PlanetExWeb.Endpoint,
          @server_farm_supervisor
        ],
        & &1
      )

    opts = [strategy: :one_for_one, name: PlanetEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PlanetExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
