defmodule PlanetWeb.RssControllerTest do
  use PlanetWeb.ConnCase
  import PlanetWeb.Support
  alias Planet.Core.ServerFarmSupervisor
  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  @stub_feed_xml atom_fixture([author: "Mitchell Hanberg"], 2)

  setup do
    Mox.stub(FetchMock, :get, fn _ -> @stub_feed_xml end)

    :ok
  end

  describe "index/2" do
    setup do
      start_supervised!(Planet.Core.ServerFarmSupervisor)

      :ok
    end

    test "should render all rss feeds", %{conn: conn} do
      feeds = [
        feed_fixture(%{url: "url1"}),
        feed_fixture(%{url: "url2"}),
        feed_fixture(%{url: "url3"})
      ]

      conn = get conn, "/rss"

      assert html_response(conn, 200) =~ "Feeds"

      for feed <- feeds do
        assert html_response(conn, 200) =~ feed.url
      end
    end
  end

  describe "create/2" do
    @valid_attrs %{
      rss: %{
        name: "Mitchell Hanberg's Blog",
        url: "mitchblog.com",
        author: "Mitchell Hanberg",
        is_sharepoint: false
      }
    }

    setup %{conn: conn} do
      start_supervised!(Planet.Core.ServerFarmSupervisor)
      conn = post conn, "/rss", @valid_attrs

      {:ok, conn: conn}
    end

    test "should create an rss feed", %{conn: conn} do
      assert Repo.get_by!(Planet.Feeds.Rss, url: "mitchblog.com")
      assert get_flash(conn, :success)
    end

    test "should redirect to new template on success", %{conn: conn} do
      assert redirected_to(conn, 303) =~ "/rss/new"
    end

    test "should not be able to add a url twice", %{conn: conn} do
      conn = post conn, "/rss", @valid_attrs

      assert html_response(conn, 400)
    end

    test "should plant a feed in the server farm", %{conn: conn} do
      post conn, "/rss", @valid_attrs

      rss_id = Planet.Feeds.Rss |> Repo.get_by!(url: "mitchblog.com") |> Map.fetch!(:id)

      assert Planet.Core.FeedStore
             |> :sys.get_state()
             |> Map.fetch!(:feed_servers)
             |> Map.has_key?(rss_id)
    end
  end

  describe "new/2" do
    test "should render new template", %{conn: conn} do
      conn = get conn, "/rss/new"

      assert html_response(conn, 200) =~ "Add an <strong>RSS</strong> Feed"
    end
  end

  describe "edit/2" do
    test "should render edit template with current data", %{conn: conn} do
      feed = feed_fixture(%{url: "url"})

      conn = get conn, "/rss/#{feed.id}/edit"

      assert html_response(conn, 200) =~ feed.name
      assert html_response(conn, 200) =~ feed.url
      assert html_response(conn, 200) =~ feed.author
    end
  end

  describe "update/2" do
    test "should update a feed", %{conn: conn} do
      feed = feed_fixture(%{url: "url"})

      updated_attrs = %{
        rss: %{
          name: "updated name",
          url: feed.url,
          author: feed.author
        }
      }

      conn = patch(conn, "/rss/#{feed.id}", updated_attrs)

      assert redirected_to(conn, 303) =~ "/rss"
      assert get_flash(conn, :success)
    end

    test "should not be able to update a feed with another feeds url", %{conn: conn} do
      feed = feed_fixture(%{url: "url"})
      another_feed = feed_fixture(%{url: "taken_url"})

      updated_attrs = %{
        rss: %{
          name: feed.name,
          url: another_feed.url,
          author: feed.author
        }
      }

      conn = patch(conn, "/rss/#{feed.id}", updated_attrs)

      assert html_response(conn, 400)
    end
  end

  describe "delete/2" do
    test "should delete a feed", %{conn: conn} do
      feed = feed_fixture(%{url: "url"})

      start_supervised!(ServerFarmSupervisor)

      conn = delete(conn, "/rss/#{feed.id}")

      assert redirected_to(conn, 303) =~ "/rss"
      assert get_flash(conn, :success)
    end

    test "should reap a feed in the server farm", %{conn: conn} do
      rss = %{url: "url"} |> feed_fixture()
      rss_id = rss |> Map.fetch!(:id)

      start_supervised!(ServerFarmSupervisor)

      assert Planet.Core.FeedStore
             |> :sys.get_state()
             |> Map.fetch!(:feed_servers)
             |> Map.has_key?(rss_id)

      delete conn, "/rss/#{rss_id}"

      refute Planet.Core.FeedStore
             |> :sys.get_state()
             |> Map.fetch!(:feed_servers)
             |> Map.has_key?(rss_id)
    end

    test "should return a 400 when id doesn't match a feed", %{conn: conn} do
      start_supervised!(ServerFarmSupervisor)

      conn = delete(conn, "/rss/#{123_123_123}")

      assert redirected_to(conn, 303) =~ "/rss"
      assert get_flash(conn, :danger)
    end
  end
end
