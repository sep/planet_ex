defmodule Planet.Core.FeedParser.Sharepoint do
  alias Planet.Core.FeedParser.{Feed, Rss}
  import SweetXml

  def parse(html) do
    html
    |> xpath(~x"./body/rss"e)
    |> Rss.parse()
  end
end
