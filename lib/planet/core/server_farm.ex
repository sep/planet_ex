defmodule Planet.Core.ServerFarm do
  @moduledoc """
  This module handles supervising the farm of FeedServers.
  """
  use DynamicSupervisor
  alias Planet.Core.FeedServer

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def plant(feed) do
    DynamicSupervisor.start_child(__MODULE__, %{
      id: feed.id,
      start: {FeedServer, :start_link, [[rss: feed]]}
    })
  end

  def reap(child_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
