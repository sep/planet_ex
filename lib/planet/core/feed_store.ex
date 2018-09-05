defmodule Planet.Core.FeedStore do
  @moduledoc """
  This module is responsible for holding the Planet feed.
  """
  alias Planet.Core.FeedParser.Feed
  alias Planet.Core.FeedServer
  alias Planet.Core.ServerFarm

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  def servers do
    GenServer.call(__MODULE__, :servers)
  end

  def push(feeds) when is_list(feeds) do
    GenServer.cast(__MODULE__, {:push, feeds})
  end

  def store(rss) do
    GenServer.cast(__MODULE__, {:store, rss})
  end

  def update(rss) do
    GenServer.cast(__MODULE__, {:update, rss})
  end

  def remove(rss) do
    GenServer.cast(__MODULE__, {:remove, rss})
  end

  def init(_args) do
    proc_table =
      Planet.Feeds.list_rss()
      |> Enum.reduce(%{}, fn feed, acc ->
        {:ok, pid} = ServerFarm.plant(feed)

        Map.put(acc, feed.id, pid)
      end)

    initial_feed = %Feed{
      title: "Planet: The Blogs of SEP",
      url: "https://planet.sep.com",
      author: "SEPeers"
    }

    {:ok, %{feed: initial_feed, feed_servers: proc_table}}
  end

  def handle_call(:status, _f, state) do
    {:reply, state.feed, state}
  end

  def handle_call(:servers, _f, state) do
    {:reply, state.feed_servers, state}
  end

  def handle_cast({:push, feeds_to_merge}, %{feed: feed} = state) do
    merged_feed = Feed.merge(feeds_to_merge, feed)

    {:noreply, Map.put(state, :feed, merged_feed)}
  end

  def handle_cast({:store, new_rss}, %{feed_servers: feed_servers} = state) do
    {:ok, pid} = ServerFarm.plant(new_rss)

    feed_servers = Map.put(feed_servers, new_rss.id, pid)

    {:noreply, Map.put(state, :feed_servers, feed_servers)}
  end

  def handle_cast({:update, updated_rss}, %{feed_servers: feed_servers} = state) do
    server_pid = Map.fetch!(feed_servers, updated_rss.id)

    FeedServer.update(server_pid, updated_rss)

    {:noreply, state}
  end

  def handle_cast({:remove, old_rss}, %{feed_servers: feed_servers} = state) do
    {old_rss_pid, feed_servers} = Map.pop(feed_servers, old_rss.id)

    ServerFarm.reap(old_rss_pid)

    {:noreply, Map.put(state, :feed_servers, feed_servers)}
  end
end
