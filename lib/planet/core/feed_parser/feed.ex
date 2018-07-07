defmodule Planet.Core.FeedParser.Feed do
  defstruct [:title, :url, :author, entries: []]

  def with_entries(feed, page, per_page) do
    selected_entries =
      feed.entries
      |> Enum.chunk_every(per_page)
      |> Enum.at(page - 1)

    struct(feed, entries: selected_entries)
  end
end
