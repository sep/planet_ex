defmodule Planet.Core.ServerFarmTest do
  use ExUnit.Case
  import Mox
  import PlanetWeb.Support

  alias Planet.Core.ServerFarm

  setup :set_mox_global
  setup :verify_on_exit!

  setup do
    start_supervised!(ServerFarm)

    :ok
  end

  @stub_feed_xml atom_fixture([author: "Mitchell Hanberg"], 2)

  test "start a child" do
    feed = %Planet.Feeds.Rss{id: 1, url: "Feed_url"}

    FetchMock
    |> Mox.expect(:get, fn ^feed -> @stub_feed_xml end)

    assert {:ok, _} = ServerFarm.plant(feed)
  end

  test "stops a child" do
    feed = %Planet.Feeds.Rss{id: 1, url: "Feed_url"}

    FetchMock
    |> Mox.expect(:get, fn ^feed -> @stub_feed_xml end)

    {:ok, child_pid} = ServerFarm.plant(feed)

    assert :ok == ServerFarm.reap(child_pid)
  end
end
