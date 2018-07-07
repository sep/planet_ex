defmodule Planet.Core.FeedServerTest do
  use Planet.DataCase
  alias Planet.Core.{FeedServer, FeedParser}
  import Mox

  import PlanetWeb.Support

  setup :set_mox_global
  setup :verify_on_exit!

  @stub_feed_xml feed_fixture([author: "Mitchell Hanberg"], 2)

  test "server initializes with feeds from database" do
    rss_fixture(%{name: "Mitchell Hanberg's Blog", url: "feed_url"})

    FetchMock
    |> Mox.expect(:get, fn "feed_url" -> @stub_feed_xml end)

    server = start_supervised!(FeedServer)

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

    start_supervised!(FeedServer)

    assert_receive :done
  end
end
