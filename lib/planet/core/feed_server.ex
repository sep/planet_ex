defmodule Planet.Core.FeedServer do
  use GenServer
  require Logger
  alias Planet.Feeds
  alias Planet.Core.FeedParser

  @fetcher Application.get_env(:planet, :fetcher, Planet.Core.FeedFetcher)
  @timeout Application.get_env(:planet, :server_timeout)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def status(server) do
    GenServer.call(server, :status)
  end

  def init(_args) do
    initial_feed = %FeedParser.Feed{
      title: "Planet: The Blogs of SEP",
      url: "https://planet.sep.com",
      author: "SEPeers"
    }

    feed = build_feed(initial_feed)

    schedule()

    {:ok, %{planet: feed}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.planet, state}
  end

  def handle_info(:rebuild_feed, state) do
    feed = build_feed(state.planet)

    write_feed(feed)
    schedule()

    {:noreply, Map.put(state, :planet, feed)}
  end

  defp schedule() do
    Process.send_after(self(), :rebuild_feed, @timeout)
  end

  defp build_feed(feed) do
    Feeds.list_rss()
    |> Enum.map(fn rss ->
      @fetcher.get(rss)
      |> FeedParser.parse()
    end)
    |> FeedParser.Feed.merge(feed)
  end

  defp write_feed(feed) do
    Logger.info("Writing feed.xml")

    File.write!(
      "assets/static/feed.xml",
      Phoenix.View.render_to_iodata(PlanetWeb.RssView, "feed.xml", feed: feed)
    )
  end
end
