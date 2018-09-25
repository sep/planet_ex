defmodule PlanetEx.Repo do
  use Ecto.Repo, otp_app: :planetex

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, config) do
    if config[:load_from_system_env] do
      config =
        config
        |> Keyword.put(:url, System.get_env("DATABASE_URL"))
        |> Keyword.put(:pool_size, String.to_integer(System.get_env("POOL_SIZE") || "18"))

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
