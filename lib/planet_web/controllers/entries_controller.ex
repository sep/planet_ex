defmodule PlanetExWeb.EntriesController do
  use PlanetExWeb, :controller
  alias PlanetEx.Core.FeedParser.Feed
  alias PlanetEx.Core.FeedStore

  def index(conn, %{"page" => page}) do
    conn
    |> fetch_and_render_entries(String.to_integer(page))
  end

  def index(conn, _p) do
    conn
    |> fetch_and_render_entries(1)
  end

  defp fetch_and_render_entries(conn, page) do
    feed = FeedStore.status()

    chunked = Enum.chunk_every(feed.entries, 10)
    entries = chunked |> Enum.at(page - 1, [])
    pages = length(chunked)

    feed = %Feed{
      feed
      | entries: entries
    }

    conn
    |> render(:index, feed: feed, page: page, pages: pages)
  end
end
