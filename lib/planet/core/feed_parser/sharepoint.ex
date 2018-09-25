defmodule PlanetEx.Core.FeedParser.Sharepoint do
  @moduledoc """
  This modules understands how to parse a feed from Microsoft Sharepoint.
  """
  alias PlanetEx.Core.FeedParser.{Rss}
  import SweetXml

  def parse(html) do
    html
    |> xpath(~x"./body/rss"e)
    |> Rss.parse()
  end
end
