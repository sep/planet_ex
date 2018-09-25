defmodule PlanetEx.Core.FeedServer do
  @moduledoc """
  FeedServer fetches, parses, and serves the feeds on a configurable schedule.
  """
  use GenServer
  require Logger
  alias PlanetEx.Core.FeedParser

  @fetcher Application.get_env(:planetex, :fetcher, PlanetEx.Core.FeedFetcher)
  @timeout Application.get_env(:planetex, :server_timeout)

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def status(server) do
    GenServer.call(server, :status)
  end

  def update(server, rss) do
    GenServer.cast(server, {:update, rss})
  end

  def put_feed(server, feed) do
    GenServer.cast(server, {:put_feed, feed})
  end

  def stop(server) do
    GenServer.stop(server)
  end

  def init(args) do
    rss = Keyword.get(args, :rss)
    timeout = Keyword.get(args, :timeout, @timeout)

    feed = build_feed(rss)

    schedule(timeout)

    {:ok, %{feed: feed, rss: rss, timeout: timeout}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.feed, state}
  end

  def handle_cast({:update, updated_rss}, state) do
    new_state = Map.put(state, :rss, updated_rss)

    {:noreply, new_state}
  end

  def handle_cast({:put_feed, feed}, state) do
    {:noreply, Map.put(state, :feed, feed)}
  end

  def handle_info(:rebuild_feed, state) do
    self()
    |> fetch_and_build(state)
    |> Task.start()

    schedule(state.timeout)

    {:noreply, state}
  end

  defp schedule(timeout) do
    Process.send_after(self(), :rebuild_feed, timeout)
  end

  defp build_feed(rss) do
    Logger.debug(fn -> "Rebuilding feed: #{inspect rss.url}" end)

    rss
    |> @fetcher.get()
    |> FeedParser.parse()
  end

  defp fetch_and_build(server_pid, state) do
    fn ->
      put_feed(
        server_pid,
        build_feed(state.rss)
      )
    end
  end
end
