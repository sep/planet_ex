defmodule PlanetEx.Core.FeedParser.FeedTest do
  use ExUnit.Case
  alias PlanetEx.Core.FeedParser.{Entry, Feed}

  describe "merge/1" do
    test "takes a list of Feeds and returns a single Feed" do
      feeds = [
        %Feed{},
        %Feed{},
        %Feed{}
      ]

      actual = Feed.merge(feeds, %Feed{})

      assert %Feed{} = actual
    end

    test "should merge Feed entries into a single Feed in descending order by published" do
      expected_entries = [
        %Entry{
          title: "Entry1",
          published: Timex.parse!("2018-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %Entry{
          title: "Entry2",
          published: Timex.parse!("2017-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %Entry{
          title: "Entry3",
          published: Timex.parse!("2015-06-24T04:50:34-05:00", "{ISO:Extended}")
        },
        %Entry{
          title: "Entry4",
          published: Timex.parse!("2013-06-24T04:50:34-05:00", "{ISO:Extended}")
        }
      ]

      feeds = [
        %Feed{
          entries: [
            Enum.at(expected_entries, 0),
            Enum.at(expected_entries, 2)
          ]
        },
        %Feed{
          entries: [
            Enum.at(expected_entries, 1),
            Enum.at(expected_entries, 3)
          ]
        }
      ]

      actual =
        feeds
        |> Feed.merge(%Feed{})
        |> Map.get(:entries)

      assert expected_entries == actual
    end
  end
end
