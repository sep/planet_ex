defmodule PlanetEx.Feeds.Planet do
  @moduledoc """
  This schema describes the aggregated feed displayed on the home page. This is a singleton.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "planets" do
    field :author, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(planets, attrs) do
    planets
    |> cast(attrs, [:title, :url, :author])
    |> validate_required([:title, :url, :author])
  end
end
