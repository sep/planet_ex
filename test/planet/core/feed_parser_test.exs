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
        content: "<blockquote>",
        published: Timex.parse!("2018-02-22T12:00:00+00:00", "{ISO:Extended}")
      }

      actual =
        FeedParser.parse(@xml_feed)
        |> Map.get(:entries)
        |> List.first()

      assert expected_entry.title == actual.title
      assert expected_entry.url == actual.url
      assert expected_entry.author == actual.author
      assert actual.content =~ expected_entry.content
      assert expected_entry.published == actual.published
    end
  end

  describe "merge/1" do
    test "takes a list of Feed and returns a single Feed" do
      feeds = [
        %FeedParser.Feed{},
        %FeedParser.Feed{},
        %FeedParser.Feed{}
      ]

      actual = FeedParser.merge(feeds)

      assert %FeedParser.Feed{} = actual
    end

    test "merged feed has Planet's meta data" do
      expected = %FeedParser.Feed{
        title: "Planet: The Blogs of SEP",
        url: "https://planet.sep.com",
        author: "SEPeers"
      }

      actual = FeedParser.merge([])

      assert expected.title == actual.title
      assert expected.url == actual.url
      assert expected.author == actual.author
    end

    test "should merge Feed entries into a single Feed in descending order by published" do
      expected_entries = [
        %FeedParser.Entry{
          title: "Entry1",
          published: Timex.parse!("2018-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %FeedParser.Entry{
          title: "Entry2",
          published: Timex.parse!("2017-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %FeedParser.Entry{
          title: "Entry3",
          published: Timex.parse!("2015-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %FeedParser.Entry{
          title: "Entry4",
          published: Timex.parse!("2013-06-24T04:50:34-05:00", "{ISO:Extended}")
        }
      ]

      feeds = [
        %FeedParser.Feed{
          entries: [
            Enum.at(expected_entries, 0),
            Enum.at(expected_entries, 2)
          ]
        },
        %FeedParser.Feed{
          entries: [
            Enum.at(expected_entries, 1),
            Enum.at(expected_entries, 3)
          ]
        }
      ]

      actual =
        FeedParser.merge(feeds)
        |> Map.get(:entries)

      assert expected_entries == actual
    end
  end
end
