defmodule Planet.Feeds.Rss do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rss" do
    field :author, :string
    field :name, :string
    field :url, :string
    field :is_sharepoint, :boolean

    timestamps()
  end

  @doc false
  def changeset(rss, attrs \\ %{}) do
    rss
    |> cast(attrs, [:name, :url, :author, :is_sharepoint])
    |> validate_required([:name, :url, :author, :is_sharepoint])
    |> unique_constraint(:url, message: "this feed has already been added.")
  end
end
