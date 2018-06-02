defmodule Planet.Feeds.Rss do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rss" do
    field :author, :string
    field :name, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(rss, attrs \\ %{}) do
    rss
    |> cast(attrs, [:name, :url, :author])
    |> validate_required([:name, :url, :author])
    |> unique_constraint(:url, message: "this feed has already been added.")
  end
end
