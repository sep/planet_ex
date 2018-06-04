defmodule Planet.Core.FeedParser do
  import SweetXml

  defmodule Feed do
    defstruct [:title, :url, :author, :entries]
  end

  defmodule Entry do
    defstruct [:title, :url, :author, :content]
  end

  def parse(raw_feed) do
    %Feed{}
    |> put_title(raw_feed)
    |> put_url(raw_feed)
    |> put_author(raw_feed)
    |> put_entries(raw_feed)
  end

  defp put_entries(%Feed{} = feed, xml) do
    entries =
      stream_tags(xml, :entry)
      |> Stream.map(&to_entry/1)
      |> Enum.to_list()

    struct(feed, entries: entries)
  end

  defp to_entry({:entry, entryXml}) do
    %Entry{}
    |> put_title(entryXml)
    |> put_url(entryXml)
    |> put_author(entryXml)
    |> put_content(entryXml)
  end

  defp put_content(%Entry{} = entry, xml) do
    struct(entry, content: xpath(xml, ~x"./content/text()"s))
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
end
