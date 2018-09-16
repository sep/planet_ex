defmodule Planet.Repo do
  use Ecto.Repo, otp_app: :planet

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    opts =
      opts
      |> Keyword.put(:url, System.get_env("DATABASE_URL"))
      |> Keyword.put(:pool_size, String.to_integer(System.get_env("POOL_SIZE")))

    {:ok, opts}
  end
end
