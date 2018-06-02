defmodule PlanetWeb.RssControllerTest do
  use PlanetWeb.ConnCase

  describe "create/2" do
    @valid_attrs %{
      rss: %{
        name: "Mitchell Hanberg's Blog",
        url: "mitchblog.com",
        author: "Mitchell Hanberg"
      }
    }

    setup %{conn: conn} do
      conn = post conn, "/rss", @valid_attrs

      {:ok, conn: conn}
    end

    test "should respond with 201 on success", %{conn: conn} do
      assert conn.status == 201
    end

    test "should create an rss speed" do
      assert Repo.get_by!(Planet.Feeds.Rss, url: "mitchblog.com")
    end

    test "should render new template on success", %{conn: conn} do
      assert html_response(conn, 201) =~ "Add an <strong>RSS</strong> Feed"
    end

    test "should not be able to add a url twice", %{conn: conn} do
      conn = post conn, "/rss", @valid_attrs

      assert html_response(conn, 400)
    end
  end

  describe "new/2" do
    test "should render new template", %{conn: conn} do
      conn = get conn, "/rss/new"

      assert html_response(conn, 200) =~ "Add an <strong>RSS</strong> Feed"
    end
  end
end
