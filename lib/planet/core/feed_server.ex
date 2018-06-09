defmodule Planet.Core.FeedServer do
  use GenServer
  alias Planet.Feeds
  alias Planet.Core.FeedParser

  @fetcher Application.get_env(:planet, :fetcher, Planet.Core.FeedFetcher)

  def start_link(opts \\ []) do
    {name, opts} = Keyword.pop(opts, :name, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def status(server) do
    GenServer.call(server, :status)
  end

  def init(args \\ Keyword.new()) do
    timeout = Keyword.get(args, :timeout, 60000)

    feed = build_feed()

    schedule(timeout)

    {:ok, %{planet: feed, timeout: timeout}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.planet, state}
  end

  def handle_info(:rebuild_feed, state) do
    feed = build_feed()

    write_feed(feed)
    schedule(state.timeout)

    {:noreply, Map.put(state, :planet, feed)}
  end

  defp schedule(timeout) do
    Process.send_after(self(), :rebuild_feed, timeout)
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
