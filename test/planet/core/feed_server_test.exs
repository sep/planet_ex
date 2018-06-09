defmodule Planet.Core.FeedServerTest do
  use Planet.DataCase
  alias Planet.Core.{FeedServer, FeedParser}

  import PlanetWeb.Factory

  @stub_feed_xml File.read!("test/fixtures/feed_fixture.xml")
  @server_opts [timeout: 0, name: :test_server]

  setup_all do
    Mox.defmock(FetchMock, for: Planet.Core.FeedFetcher)

    :ok
  end

  setup do
    Mox.set_mox_global()
    Mox.verify_on_exit!()
  end

  test "server starts up" do
    server = start_supervised!({FeedServer, @server_opts})

    assert GenServer.whereis(server)
  end

  test "server initializes with feeds from database" do
    rss_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})

    FetchMock
    |> Mox.expect(:get, fn "feed_url" -> @stub_feed_xml end)

    server = start_supervised!({FeedServer, @server_opts})

    assert %FeedParser.Feed{
             entries: [
               %FeedParser.Entry{},
               %FeedParser.Entry{}
             ]
           } = FeedServer.status(server)
  end

  test "server fetches feeds periodically" do
    rss_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})
    id = self()

    FetchMock
    |> Mox.expect(:get, fn "feed_url" -> @stub_feed_xml end)
    |> Mox.expect(:get, fn "feed_url" -> send(id, :done) end)

    start_supervised!({FeedServer, @server_opts})

    assert_receive :done
  end
end
