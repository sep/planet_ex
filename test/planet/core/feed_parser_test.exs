defmodule Planet.Core.FeedParserTest do
  use ExUnit.Case
  alias Planet.Core.FeedParser

  describe "parse/1" do
    @xml_feed File.read!("test/fixtures/feed_fixture.xml")

    test "turns an xml feed into a Feed struct" do
      actual = FeedParser.parse(@xml_feed)

      assert %FeedParser.Feed{} = actual
    end

    test "parses the title, url, and author fields" do
      expected = %FeedParser.Feed{
        title: "Mitchell Hanberg’s Blog",
        url: "https://www.mitchellhanberg.com/",
        author: "Mitchell Hanberg"
      }

      actual = FeedParser.parse(@xml_feed)

      assert expected.title == actual.title
      assert expected.url == actual.url
      assert expected.author == actual.author
    end

    test "parses the entries into an entries field that is a list of Entry structs" do
      actual = FeedParser.parse(@xml_feed)

      assert [%FeedParser.Entry{}, %FeedParser.Entry{}] = actual.entries
    end

    test "parses all entries" do
      actual = FeedParser.parse(@xml_feed)

      assert 2 == Enum.count(actual.entries)
    end

    test "parses entry data from feed" do
      expected_entry = %FeedParser.Entry{
        title: "Integrate and Deploy React with Phoenix",
        url:
          "https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix",
        author: "Mitchell Hanberg",
        content: "<blockquote>"
      }

      actual =
        FeedParser.parse(@xml_feed)
        |> Map.get(:entries)
        |> List.first()

      assert expected_entry.title == actual.title
      assert expected_entry.url == actual.url
      assert expected_entry.author == actual.author
      assert actual.content =~ expected_entry.content
    end
  end
end
