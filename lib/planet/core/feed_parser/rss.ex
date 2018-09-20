defmodule Planet.Core.FeedParser.Rss do
  @moduledoc """
  This module understands how to parse an RSS feed.
  """
  require Logger
  alias Planet.Core.FeedParser.{Entry, Feed}
  import SweetXml

  def parse(xml) do
    xml = xpath(xml, ~x"./channel"e)

    %Feed{}
    |> put_title(xml)
    |> put_url(xml)
    |> put_entries(xml)
  end

  defp put_entries(%Feed{} = feed, xml) do
    entries =
      xml
      |> xpath(~x"./item"le)
      |> Enum.map(fn entry -> to_entry(entry, feed) end)

    struct(feed, entries: entries)
  end

  defp to_entry(entry_xml, feed) do
    %Entry{}
    |> put_title(entry_xml)
    |> put_url(entry_xml)
    |> put_author(entry_xml)
    |> put_content(entry_xml, feed)
    |> put_published(entry_xml)
  end

  defp put_content(%Entry{} = entry, xml, feed) do
    content =
      xml
      |> get_content()
      |> Entry.convert_relative_urls(feed.url)

    struct(entry, content: content)
  end

  defp get_content(xml) do
    content_encoded(xml) || description(xml) || ""
  end

  defp content_encoded(xml) do
    xpath(xml, ~x"./content:encoded/text()"so)
  end

  defp description(xml) do
    xml
    |> xpath(~x"./description/text()"so)
    |> String.trim()
    |> case do
      "" ->
        xml
        |> xpath(~x"./description")
        |> elem(8)
        |> :xmerl.export_simple_content(:xmerl_html)
        |> List.to_string()

      desc ->
        desc
    end
  end

  defp put_published(%Entry{} = entry, xml) do
    published =
      (xpath(xml, ~x"./pubDate/text()"so) || xpath(xml, ~x"./pubdate/text()"so))
      |> parse_date

    struct(entry, published: published)
  end

  defp parse_date(date) do
    parse_rfc_822(date) || parse_rfc_1123(date) || parse_rfc_1123_published_on(date) ||
      parse_rfc_822_sharepoint_bastard(date)
  end

  def parse_rfc_822(date) do
    case Timex.parse(date, "{RFC822}") do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  def parse_rfc_1123(date) do
    case Timex.parse(date, "{RFC1123}") do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  def parse_rfc_1123_published_on(date) do
    case Timex.parse(date, "Published on {RFC1123}") do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  def parse_rfc_822_sharepoint_bastard(date) do
    case Timex.parse(date, "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} {Zabbr}") do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  defp put_title(struct, xml) do
    struct(struct, title: xpath(xml, ~x"./title/text()"s))
  end

  defp put_url(struct, xml) do
    url = xpath(xml, ~x"./link/text()"so) || xpath(xml, ~x"./guid/text()"so) || ""

    struct(struct, url: url)
  end

  defp put_author(struct, xml) do
    author = xpath(xml, ~x"./author/text()"so) || xpath(xml, ~x"./dc:creator/text()"so)

    struct(struct, author: author)
  end
end
