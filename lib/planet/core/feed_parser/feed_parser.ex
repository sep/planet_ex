defmodule Planet.Core.FeedParser do
  alias Planet.Core.FeedParser.{Feed, Atom, Rss}

  def parse(""), do: %Feed{}

  def parse(raw_feed) do
    SweetXml.parse(raw_feed)
    |> case do
      {_, :feed, _, _, _, _, _, _, _, _, _, _} = feed ->
        Atom.parse(feed)

      {_, :rss, _, _, _, _, _, _, _, _, _, _} = feed ->
        Rss.parse(feed)
    end
  end
end
