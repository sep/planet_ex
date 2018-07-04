defmodule PlanetWeb.Features.RssTest do
  use PlanetWeb.FeatureCase
  alias Planet.Core.FeedServer
  import PlanetWeb.Factory
  import Mox

  import Wallaby.Query

  setup :set_mox_global
  setup :verify_on_exit!

  @stub_feed_xml File.read!("test/fixtures/feed_fixture.xml")

  test "feeds should be listed in descending order by name", %{session: session} do
    rss_fixture(%{name: "zname", url: "zurl"})
    rss_fixture(%{name: "aname", url: "aurl"})
    rss_fixture(%{name: "mname", url: "murl"})

    feeds =
      session
      |> visit("/rss")
      |> find(css("#feedName", count: 3))

    feeds
    |> List.first()
    |> assert_text("aname")

    feeds
    |> List.last()
    |> assert_text("zname")
  end

  test "should be able to add an RSS feed", %{session: session} do
    session
    |> visit("/rss/new")
    |> fill_in(Query.text_field("Name"), with: "Blog title")
    |> fill_in(Query.text_field("URL"), with: "https://bloggington.blog")
    |> fill_in(Query.text_field("Author"), with: "The Blog Man")
    |> click(Query.button("Add"))
    |> assert_text("Success!")
  end

  test "should display blog posts on the home page", %{session: session} do
    rss_fixture(%{
      name: "Mitchell Hanberg's Blog",
      url: "https://www.mitchellhanberg.com/feed.xml"
    })
    IO.puts("JUST ADDED FIXTURE")

    FetchMock
    |> Mox.stub(:get, fn _ -> @stub_feed_xml end)

    pid = start_supervised!(FeedServer)
    IO.inspect(pid, label: "server in test: ")

    session
    |> visit("/")
    |> assert_text("Integrate and Deploy React with Phoenix")
  end
end
