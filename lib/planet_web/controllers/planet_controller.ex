defmodule PlanetWeb.PlanetController do
  use PlanetWeb, :controller

  alias Planet.Feeds

  def edit(conn, %{"id" => id}) do
    planet = Feeds.get_planet!(id)
    changeset = Feeds.change_planet(planet)
    render(conn, "edit.html", planet: planet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "planet" => planet_params}) do
    planet = Feeds.get_planet!(id)

    with {:ok, updated_planet = %Feeds.Planet{}} <- Feeds.update_planet(planet, planet_params),
         Planet.Core.FeedStore.update_planet(updated_planet) do
      conn
      |> put_flash(:success, "Planet updated successfully.")
      |> redirect(to: entries_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "Planet failed to update.")
        |> render("edit.html", planet: planet, changeset: changeset)
    end
  end
end
