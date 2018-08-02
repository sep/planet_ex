defmodule Planet.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias Planet.Repo

  alias Planet.Feeds.Rss

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
end
