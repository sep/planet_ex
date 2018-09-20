defmodule Planet.Core.ServerFarmSupervisor do
  @moduledoc """
  This modules supervises the process that fetch and serve the feeds.
  """
  use Supervisor
  alias Planet.Core.Cron
  alias Planet.Core.FeedServer
  alias Planet.Core.FeedStore
  alias Planet.Core.ServerFarm

  require Logger

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      ServerFarm,
      FeedStore,
      refresh_feed_store_job(),
      write_feed_to_disk_job()
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp refresh_feed_store_job do
    Supervisor.child_spec(
      {
        Cron,
        fn ->
          feed_servers = FeedStore.servers()

          feeds =
            for pid <- Map.values(feed_servers) do
              FeedServer.status(pid)
            end

          FeedStore.push(feeds)
        end
      },
      id: {Cron, :refresher}
    )
  end

  defp write_feed_to_disk_job do
    Supervisor.child_spec(
      {
        Cron,
        fn ->
          feed = FeedStore.status()

          Logger.debug(fn -> "Writing feed.xml" end)

          File.write!(
            Application.app_dir(:planet, "priv/static/feed.xml"),
            Phoenix.View.render_to_iodata(PlanetWeb.RssView, "feed.xml", feed: feed)
          )
        end
      },
      id: {Cron, :feed_writer}
    )
  end
end
