defmodule PlanetEx.Core.FeedParser.Atom do
  @moduledoc """
  This module understands how to parse an Atom feed.
  """
  alias PlanetEx.Core.FeedParser.{Entry, Feed}
  import SweetXml

  def parse(xml) do
    %Feed{}
    |> put_title(xml)
    |> put_url(xml)
    |> put_author(xml)
    |> put_entries(xml)
  end

  defp put_entries(%Feed{} = feed, xml) do
    entries =
      xml
      |> xpath(~x"./entry"l)
      |> Enum.map(fn entry -> to_entry(entry, feed) end)

    struct(feed, entries: entries)
  end

  defp to_entry(entry_xml, feed) do
    %Entry{}
    |> put_title(entry_xml)
    |> put_url(entry_xml)
    |> put_author(entry_xml, feed)
    |> put_content(entry_xml, feed)
    |> put_published(entry_xml)
  end

  defp put_content(%Entry{} = entry, xml, feed) do
    content =
      xml
      |> xpath(~x"./content/text()"s)
      |> Entry.convert_relative_urls(feed.url)

    struct(entry, content: content)
  end

  defp put_published(%Entry{} = entry, xml) do
    published =
      xml
      |> xpath(~x"./updated/text()"s)
      |> parse_date

    struct(entry, published: published)
  end

  defp parse_date(date) do
    Timex.parse!(date, "{ISO:Extended}")
  end

  defp put_title(struct, xml) do
    struct(struct, title: xpath(xml, ~x"./title/text()"s))
  end

  defp put_url(struct, xml) do
    struct(struct, url: xpath(xml, ~x"./link[@rel='alternate']/@href"s))
  end

  defp put_author(struct, xml) do
    struct(struct, author: xpath(xml, ~x"./author/name/text()"s))
  end

  defp put_author(struct, xml, feed) do
    author =
      case xpath(xml, ~x"./author/name/text()"s) do
        "" ->
          feed.author

        entry_author ->
          entry_author
      end

    struct(struct, author: author)
  end
end
