defmodule Planet.Core.FeedParser do
  require Logger
  alias Planet.Core.FeedParser.{Feed, Atom, Rss, Sharepoint}

  def parse(""), do: %Feed{}

  def parse(raw_feed) do
    SweetXml.parse(raw_feed)
    |> case do
      {_, :feed, _, _, _, _, _, _, _, _, _, _} = feed ->
        Atom.parse(feed)

      {_, :rss, _, _, _, _, _, _, _, _, _, _} = feed ->
        Rss.parse(feed)

      {_, :html, _, _, _, _, _, _, _, _, _, _} = feed ->
        Sharepoint.parse(feed)

      unknown ->
        Logger.error("Error parsing a feed, this is what I got: #{inspect raw_feed}")
        Logger.error("This is what was parsed #{inspect unknown}")
        nil
    end
  end
end
