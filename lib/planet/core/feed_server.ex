defmodule Planet.Core.FeedServer do
  @moduledoc """
  FeedServer fetches, parses, and serves the feeds on a configurable schedule.
  """
  use GenServer
  require Logger
  alias Planet.Core.FeedParser

  @fetcher Application.get_env(:planet, :fetcher, Planet.Core.FeedFetcher)
  @timeout Application.get_env(:planet, :server_timeout)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def status(server) do
    GenServer.call(server, :status)
  end

  def update(server, rss) do
    GenServer.cast(server, {:update, rss})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  def init(args) do
    rss = Keyword.get(args, :rss)
    feed = build_feed(rss)

    schedule()

    {:ok, %{feed: feed, rss: rss}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.feed, state}
  end

  def handle_cast({:update, updated_rss}, state) do
    new_state = Map.put(state, :rss, updated_rss)

    {:noreply, new_state}
  end

  def handle_info(:rebuild_feed, state) do
    feed = build_feed(state.rss)

    schedule()

    {:noreply, Map.put(state, :feed, feed)}
  end

  defp schedule do
    Process.send_after(self(), :rebuild_feed, @timeout)
  end

  defp build_feed(rss) do
    Logger.debug(fn -> "Rebuilding feed: #{inspect rss.url}" end)

    rss
    |> @fetcher.get()
    |> FeedParser.parse()
  end
end
