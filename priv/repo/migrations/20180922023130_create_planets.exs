defmodule PlanetEx.Repo.Migrations.CreatePlanets do
  use Ecto.Migration

  def up do
    create table(:planets) do
      add :title, :string
      add :url, :string
      add :author, :string

      timestamps()
    end

    flush()

    now = NaiveDateTime.utc_now()

    PlanetEx.Repo.insert_all(
      "planets",
      [
        [
          title: "Our Planet Feed",
          url: "Our Planet URL",
          author: "Our Planet Contributors",
          inserted_at: now,
          updated_at: now
        ]
      ]
    )
  end

  def down do
    drop table(:planets)
  end
end
