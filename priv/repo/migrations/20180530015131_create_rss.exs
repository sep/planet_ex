defmodule Planet.Repo.Migrations.CreateRss do
  use Ecto.Migration

  def change do
    create table(:rss) do
      add :name, :string
      add :url, :string
      add :author, :string

      timestamps
    end

    create unique_index(:rss, :url)
    create index(:rss, :name)
    create index(:rss, :author)
  end
end
