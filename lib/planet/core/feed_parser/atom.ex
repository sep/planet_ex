defmodule Planet.Core.FeedParser.Atom do
  alias Planet.Core.FeedParser.{Feed, Entry}
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
      xpath(xml, ~x"./entry"l)
      |> Enum.map(fn entry -> to_entry(entry, feed) end)

    struct(feed, entries: entries)
  end

  defp to_entry(entryXml, feed) do
    %Entry{}
    |> put_title(entryXml)
    |> put_url(entryXml)
    |> put_author(entryXml, feed)
    |> put_content(entryXml, feed)
    |> put_published(entryXml)
  end

  defp put_content(%Entry{} = entry, xml, feed) do
    content =
      xpath(xml, ~x"./content/text()"s)
      |> String.replace(~r{(href|src)=(?:"|')/(.*?)(?:"|')}, "\\1=\"#{feed.url}\\2\"")

    struct(entry, content: content)
  end

  defp put_published(%Entry{} = entry, xml) do
    published =
      xpath(xml, ~x"./published/text()"s)
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
    struct(struct, url: xpath(xml, ~x"./id/text()"s))
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
