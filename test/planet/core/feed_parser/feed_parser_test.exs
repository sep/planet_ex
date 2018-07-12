defmodule Planet.Core.FeedParserTest do
  use ExUnit.Case
  alias Planet.Core.FeedParser
  import PlanetWeb.Support

  test "returns and empty string when it is passed an Feed" do
    assert FeedParser.parse("") == %FeedParser.Feed{}
  end

  describe "parse/1 for atom feeds" do
    @atom_feed atom_fixture([author: "Mitchell Hanberg"], 5)

    test "turns an atom feed into a Feed struct" do
      actual = FeedParser.parse(@atom_feed)

      assert %FeedParser.Feed{} = actual
    end

    test "parses the title, url, and author fields" do
      expected = %FeedParser.Feed{
        title: "Mitchell Hanberg’s Blog",
        url: "https://www.mitchellhanberg.com/",
        author: "Mitchell Hanberg"
      }

      actual = FeedParser.parse(@atom_feed)

      assert expected.title == actual.title
      assert expected.url == actual.url
      assert expected.author == actual.author
    end

    test "parses all entries" do
      actual = FeedParser.parse(@atom_feed)

      assert 5 == Enum.count(actual.entries)
      assert %FeedParser.Entry{} = List.first(actual.entries)
    end

    test "parses entry data from feed" do
      expected_entry = %FeedParser.Entry{
        title: "Integrate and Deploy React with Phoenix",
        url:
          "https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix",
        author: "Mitchell Hanberg",
        content: "<blockquote>",
        published: Timex.parse!("2018-02-22T12:00:00+00:00", "{ISO:Extended}")
      }

      actual =
        FeedParser.parse(@atom_feed)
        |> Map.get(:entries)
        |> List.first()

      assert expected_entry.title == actual.title
      assert expected_entry.url == actual.url
      assert expected_entry.author == actual.author
      assert actual.content =~ expected_entry.content
      assert expected_entry.published == actual.published
    end

    test "replaces empty entry author field with one from feed author field" do
      xml_feed = atom_fixture(author: "Mitchell Hanberg", entry: nil)

      expected_entry = %FeedParser.Entry{
        title: "Integrate and Deploy React with Phoenix",
        url:
          "https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix",
        author: "Mitchell Hanberg",
        content: "<blockquote>",
        published: Timex.parse!("2018-02-22T12:00:00+00:00", "{ISO:Extended}")
      }

      actual =
        FeedParser.parse(xml_feed)
        |> Map.get(:entries)
        |> List.first()

      assert expected_entry.author == actual.author
    end

    test "replaces relative links in href values with absolute ones" do
      expected_entry = %FeedParser.Entry{
        title: "Integrate and Deploy React with Phoenix",
        url:
          "https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix",
        author: "Mitchell Hanberg",
        content: ~s{<a href="https://www.mitchellhanberg.com/relativelink">},
        published: Timex.parse!("2018-02-22T12:00:00+00:00", "{ISO:Extended}")
      }

      actual =
        FeedParser.parse(@atom_feed)
        |> Map.get(:entries)
        |> List.first()

      assert actual.content =~ expected_entry.content
    end

    test "replaces relative img srcs with absolute ones" do
      expected_entry = %FeedParser.Entry{
        title: "Integrate and Deploy React with Phoenix",
        url:
          "https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix",
        author: "Mitchell Hanberg",
        content: "<img src=\"https://www.mitchellhanberg.com/images/contact.png\"",
        published: Timex.parse!("2018-02-22T12:00:00+00:00", "{ISO:Extended}")
      }

      actual =
        FeedParser.parse(@atom_feed)
        |> Map.get(:entries)
        |> List.first()

      assert actual.content =~ expected_entry.content
    end
  end

  describe "parse/1 for rss feeds" do
    @rss_feed rss_fixture(5)

    test "turns an rss feed into a Feed struct" do
      actual = FeedParser.parse(@rss_feed)

      assert %FeedParser.Feed{} = actual
    end

    test "parses the title and url fields" do
      expected = %FeedParser.Feed{
        title: "SEP Blog",
        url: "https://www.sep.com/sep-blog"
      }

      actual = FeedParser.parse(@rss_feed)

      assert expected.title == actual.title
      assert expected.url == actual.url
    end

    test "parses all entries" do
      actual = FeedParser.parse(@rss_feed)

      assert 5 == Enum.count(actual.entries)
      assert %FeedParser.Entry{} = List.first(actual.entries)
    end

    test "parses entry data from feed" do
      expected_entry = %FeedParser.Entry{
        title: "Meet the 2018 Interns",
        url: "https://www.sep.com/sep-blog/2018/06/19/meet-the-2018-interns/",
        content: "Berkley",
        author: "SEP Interns",
        published:
          Timex.parse!(
            "Tue, 19 Jun 2018 15:53:03 +0000",
            "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} {Z}"
          )
      }

      actual =
        FeedParser.parse(@rss_feed)
        |> Map.get(:entries)
        |> List.first()

      assert expected_entry.title == actual.title
      assert expected_entry.url == actual.url
      assert actual.content =~ expected_entry.content
      assert expected_entry.published == actual.published
      assert expected_entry.author == actual.author
    end
  end
end
