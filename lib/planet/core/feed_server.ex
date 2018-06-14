defmodule Planet.Core.FeedServer do
  use GenServer
  alias Planet.Feeds
  alias Planet.Core.FeedParser

  @fetcher Application.get_env(:planet, :fetcher, Planet.Core.FeedFetcher)
  @timeout Application.get_env(:planet, :server_timeout)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
    |> IO.inspect(label: "pid: ")
  end

  def status(server) do
    GenServer.call(server, :status)
  end

  def init(_args) do
    feed = build_feed()

    schedule()

    {:ok, %{planet: feed}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.planet, state}
  end

  def handle_info(:rebuild_feed, state) do
    feed = build_feed()

    write_feed(feed)
    schedule()

    {:noreply, Map.put(state, :planet, feed)}
  end

  defp schedule() do
    Process.send_after(self(), :rebuild_feed, @timeout)
  end

  defp build_feed() do
    Feeds.list_rss()
    |> Enum.map(fn rss ->
      @fetcher.get(rss.url)
      |> FeedParser.parse()
    end)
    |> FeedParser.merge()
  end

  defp write_feed(feed) do
    File.write!(
      "assets/static/feed.xml",
      Phoenix.View.render_to_iodata(PlanetWeb.RssView, "feed.xml", feed: feed)
    )
  end
end
