defmodule Planet.Core.ServerFarmSupervisorTest do
  use Planet.DataCase
  alias Planet.Core.FeedParser.{Entry, Feed}
  alias Planet.Core.{FeedStore, ServerFarm, ServerFarmSupervisor}
  import PlanetWeb.Support
  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  @stub_feed_xml atom_fixture([author: "Mitchell Hanberg"], 2)

  setup do
    Mox.stub(FetchMock, :get, fn _ -> @stub_feed_xml end)

    :ok
  end

  test "should start a feed server for each feed in the database" do
    feed_fixture(%{name: "Blog1", url: "feed_url1"})
    feed_fixture(%{name: "Blog2", url: "feed_url2"})
    feed_fixture(%{name: "Blog3", url: "feed_url3"})

    start_supervised!(ServerFarmSupervisor)

    assert 3 ==
             FeedStore
             |> :sys.get_state()
             |> Map.fetch!(:feed_servers)
             |> Map.keys()
             |> Enum.count()
  end

  test "retrieves the aggregated feed" do
    start_supervised!(ServerFarmSupervisor)

    assert %Planet.Core.FeedParser.Feed{} = FeedStore.status()
  end

  test "can merge a feed" do
    start_supervised!(ServerFarmSupervisor)

    FeedStore.push([
      %Feed{
        title: "Blerg",
        url: "https://blergnation.com",
        author: "Blergman",
        entries: [
          %Entry{
            title: "Blerg title",
            url: "Blerg url",
            author: "Blerg author",
            content: "Blerg content",
            published: "Blerg date"
          }
        ]
      }
    ])

    %{feed: actual} = :sys.get_state(FeedStore)

    assert "Planet: The Blogs of SEP" == actual.title
    assert "https://planet.sep.com" == actual.url
    assert "SEPeers" == actual.author

    assert "Blerg content" ==
             actual.entries
             |> List.first()
             |> Map.fetch!(:content)
  end

  test "stores a new feed" do
    start_supervised!(ServerFarmSupervisor)

    new_feed = feed_fixture(%{name: "Blog1", url: "feed_url1"})
    new_feed_id = new_feed.id

    FeedStore.store(new_feed)

    actual = :sys.get_state(FeedStore).feed_servers

    assert Map.has_key?(actual, new_feed_id)

    assert 1 == ServerFarm |> DynamicSupervisor.which_children() |> Enum.count()
  end

  test "stops an old feed" do
    old_feed = feed_fixture()

    start_supervised!(ServerFarmSupervisor)

    FeedStore.remove(old_feed)

    actual =
      FeedStore
      |> :sys.get_state()
      |> Map.get(:feed_servers)
      |> Map.keys()

    refute actual |> Enum.any?(fn id -> id == old_feed.id end)

    assert 0 == ServerFarm |> DynamicSupervisor.which_children() |> Enum.count()
  end
end
