defmodule Planet.Repo.Migrations.AddSharepointColumnToRssTable do
  use Ecto.Migration

  def change do
    alter table("rss") do
      add :is_sharepoint, :boolean, default: false, null: false
    end
  end
end
