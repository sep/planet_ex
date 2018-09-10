defmodule Planet.Core.FeedServerTest do
  use Planet.DataCase
  alias Planet.Core.{FeedParser, FeedServer}

  import PlanetWeb.Support

  @stub_feed_xml atom_fixture([author: "Mitchell Hanberg"], 2)

  test "server initializes with feed" do
    feed = feed_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})

    FetchMock
    |> Mox.expect(:get, fn ^feed -> @stub_feed_xml end)

    server = start_supervised!({FeedServer, [rss: feed]})

    assert %FeedParser.Feed{
             entries: [
               %FeedParser.Entry{},
               %FeedParser.Entry{}
             ]
           } = FeedServer.status(server)
  end

  test "server fetches feeds periodically" do
    feed = feed_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})
    id = self()

    FetchMock
    |> Mox.expect(:get, fn ^feed -> @stub_feed_xml end)
    |> Mox.expect(:get, fn ^feed ->
      send(id, :done)
      @stub_feed_xml
    end)

    start_supervised!({FeedServer, [rss: feed, timeout: 1]})

    assert_receive :done
  end

  test "stops the server" do
    feed = feed_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})

    FetchMock
    |> Mox.stub(:get, fn _ -> @stub_feed_xml end)

    feed_server = start_supervised!({FeedServer, [rss: feed]})

    FeedServer.stop(feed_server)
    alive? = Process.alive?(feed_server)

    refute alive?
  end

  test "updates the server" do
    stale_feed = feed_fixture()
    expected_name = "new author name"
    updated_feed = struct(stale_feed, author: expected_name)

    FetchMock
    |> Mox.stub(:get, fn _ -> @stub_feed_xml end)

    feed_server = start_supervised!({FeedServer, [rss: stale_feed]})

    FeedServer.update(feed_server, updated_feed)

    assert feed_server
           |> :sys.get_state()
           |> Map.fetch!(:rss)
           |> Map.fetch!(:author) == expected_name
  end
end
