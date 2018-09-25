defmodule PlanetEx.Core.FeedStore do
  @moduledoc """
  This module is responsible for holding the PlanetEx feed.
  """
  alias PlanetEx.Core.FeedParser.Feed
  alias PlanetEx.Core.FeedServer
  alias PlanetEx.Core.ServerFarm

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

  def update_planet(planet) do
    GenServer.cast(__MODULE__, {:update_planet, planet})
  end

  def remove(rss) do
    GenServer.cast(__MODULE__, {:remove, rss})
  end

  def init(_args) do
    proc_table =
      PlanetEx.Feeds.list_rss()
      |> Enum.reduce(%{}, fn feed, acc ->
        {:ok, pid} = ServerFarm.plant(feed)

        Map.put(acc, feed.id, pid)
      end)

    our_planet = PlanetEx.Feeds.get_planet!(1)

    initial_feed = %Feed{
      title: our_planet.title,
      url: our_planet.url,
      author: our_planet.author
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

  def handle_cast({:update_planet, updated_planet}, %{feed: feed} = state) do
    updated_feed = %Feed{
      title: updated_planet.title,
      url: updated_planet.url,
      author: updated_planet.author,
      entries: feed.entries
    }

    {:noreply, Map.put(state, :feed, updated_feed)}
  end

  def handle_cast({:remove, old_rss}, %{feed_servers: feed_servers} = state) do
    {old_rss_pid, feed_servers} = Map.pop(feed_servers, old_rss.id)

    ServerFarm.reap(old_rss_pid)

    {:noreply, Map.put(state, :feed_servers, feed_servers)}
  end
end
