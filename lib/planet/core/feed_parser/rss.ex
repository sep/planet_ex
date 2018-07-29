defmodule Planet.Core.FeedParser.Rss do
  require Logger
  alias Planet.Core.FeedParser.{Feed, Entry}
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
      xpath(xml, ~x"./item"le)
      |> Enum.map(fn entry -> to_entry(entry, feed) end)

    struct(feed, entries: entries)
  end

  defp to_entry(entryXml, feed) do
    %Entry{}
    |> put_title(entryXml)
    |> put_url(entryXml)
    |> put_author(entryXml)
    |> put_content(entryXml, feed)
    |> put_published(entryXml)
  end

  defp put_content(%Entry{} = entry, xml, feed) do
    content =
      (xpath(xml, ~x"./content:encoded/text()"so) ||
         xpath(xml, ~x"./description/div/*/text()"lso) |> Enum.join("\n") || "")
      |> String.replace(~r{(href|src)=(?:"|')/(.*?)(?:"|')}, "\\1=\"#{feed.url}\\2\"")

    struct(entry, content: content)
  end

  defp put_published(%Entry{} = entry, xml) do
    published =
      (xpath(xml, ~x"./pubDate/text()"so) || xpath(xml, ~x"./pubdate/text()"so))
      |> parse_date

    struct(entry, published: published)
  end

  defp parse_date(date) do
    parse_rfc_822(date) || parse_rfc_822_bastard(date) || parse_rfc_822_sharepoint_bastard(date)
  end

  def parse_rfc_822(date) do
    case Timex.parse(date, "{RFC822}") do
      {:ok, date} ->
        date

      {:error, _} ->
        nil
    end
  end

  def parse_rfc_822_bastard(date) do
    case Timex.parse(date, "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} {Z}") do
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
