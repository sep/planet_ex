defmodule PlanetWeb.EntriesController do
  use PlanetWeb, :controller
  alias Planet.Core.FeedServer

  def index(conn, _) do
    feed = FeedServer.status(FeedServer)

    conn
    |> render(:index, feed: feed)
  end
end
