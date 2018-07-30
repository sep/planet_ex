defmodule Planet.Core.FeedParser.Sharepoint do
  @moduledoc """
  This modules understands how to parse a feed from Microsoft Sharepoint.
  """
  alias Planet.Core.FeedParser.{Feed, Rss}
  import SweetXml

  def parse(html) do
    html
    |> xpath(~x"./body/rss"e)
    |> Rss.parse()
  end
end
