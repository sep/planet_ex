defmodule PlanetEx.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias PlanetEx.Repo

  alias PlanetEx.Feeds.Rss

  @doc """
  Returns the list of rss.

  ## Examples

      iex> list_rss()
      [%Rss{}, ...]

  """
  def list_rss do
    Repo.all(Rss)
  end

  @doc """
  Gets a single rss.

  Raises `Ecto.NoResultsError` if the Rss does not exist.

  ## Examples

      iex> get_rss!(123)
      %Rss{}

      iex> get_rss!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rss!(id), do: Repo.get!(Rss, id)

  @doc """
  Gets a single rss.

  ## Examples

      iex> get_rss(123)
      {:ok, %Rss{}}

      iex> get_rss(456)
      {:error, %Ecto.Changeset{}}

  """
  def get_rss(id), do: Repo.get(Rss, id)

  @doc """
  Creates a rss.

  ## Examples

      iex> create_rss(%{field: value})
      {:ok, %Rss{}}

      iex> create_rss(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rss(attrs \\ %{}) do
    %Rss{}
    |> Rss.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rss.

  ## Examples

      iex> update_rss(rss, %{field: new_value})
      {:ok, %Rss{}}

      iex> update_rss(rss, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rss(%Rss{} = rss, attrs) do
    rss
    |> Rss.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rss.

  ## Examples

      iex> delete_rss(rss)
      {:ok, %Rss{}}

      iex> delete_rss(rss)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rss(%Rss{} = rss) do
    Repo.delete(rss)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rss changes.

  ## Examples

      iex> change_rss(rss)
      %Ecto.Changeset{source: %Rss{}}

  """
  def change_rss(%Rss{} = rss) do
    Rss.changeset(rss, %{})
  end

  alias PlanetEx.Feeds.Planet

  @doc """
  Gets a single planet.

  Raises `Ecto.NoResultsError` if the Planets does not exist.

  ## Examples

      iex> get_planet!(123)
      %Planet{}

      iex> get_planet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_planet!(id), do: Repo.get!(Planet, id)

  @doc """
  Updates a planet.

  ## Examples

      iex> update_planet(planets, %{field: new_value})
      {:ok, %Planet{}}

      iex> update_planet(planet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_planet(%Planet{} = planet, attrs) do
    planet
    |> Planet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking planet changes.

  ## Examples

      iex> change_planets(planet)
      %Ecto.Changeset{source: %Planet{}}

  """
  def change_planet(%Planet{} = planet) do
    Planet.changeset(planet, %{})
  end
end
