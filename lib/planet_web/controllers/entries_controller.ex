defmodule PlanetWeb.EntriesController do
  use PlanetWeb, :controller
  alias Planet.Core.FeedServer

  def index(conn, _) do
    GenServer.whereis(FeedServer)
    |> IO.inspect(label: "whereis")
    feed = FeedServer.status(FeedServer)

    conn
    |> render(:index, feed: feed)
  end
end
