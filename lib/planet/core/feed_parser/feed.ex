defmodule Planet.Core.FeedParser.Feed do
  defstruct [:type, :title, :url, :author, entries: []]

  def with_entries(feed, page, per_page) do
    selected_entries =
      feed.entries
      |> Enum.chunk_every(per_page)
      |> Enum.at(page - 1)

    struct(feed, entries: selected_entries)
  end

  def merge(feeds, feed) when is_list(feeds) do
    struct(feed, entries: combine_and_sort_entries(feeds))
  end

  defp combine_and_sort_entries(feeds) do
    Enum.flat_map(feeds, & &1.entries)
    |> Enum.sort_by(& &1.published, &Timex.after?/2)
  end
end
