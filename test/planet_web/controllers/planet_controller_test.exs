defmodule PlanetWeb.PlanetsControllerTest do
  use PlanetWeb.ConnCase

  alias Planet.Feeds

  @create_attrs %{author: "some author", title: "some title", url: "some url"}
  @update_attrs %{
    author: "some updated author",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{author: nil, title: nil, url: nil}

  def fixture(:planet) do
    {:ok, planet} =
      %Feeds.Planet{}
      |> Feeds.Planet.changeset(@create_attrs)
      |> Repo.insert()

    planet
  end

  describe "edit planet" do
    setup [:create_planet]

    test "renders form for editing chosen planet", %{conn: conn, planet: planet} do
      conn = get conn, planet_path(conn, :edit, planet)
      assert html_response(conn, 200) =~ "Our Planet"
    end
  end

  describe "update planet" do
    setup [:create_planet]

    test "redirects when data is valid", %{conn: conn, planet: planet} do
      start_supervised!(Planet.Core.ServerFarmSupervisor)

      conn = put(conn, planet_path(conn, :update, planet), planet: @update_attrs)
      assert redirected_to(conn) == entries_path(conn, :index)

      :sys.get_state(Planet.Core.ServerFarmSupervisor)

      conn = get conn, entries_path(conn, :index)
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, planet: planet} do
      conn = put(conn, planet_path(conn, :update, planet), planet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Our Planet"
    end
  end

  defp create_planet(_) do
    planet = fixture(:planet)
    {:ok, planet: planet}
  end
end
