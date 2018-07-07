defmodule PlanetWeb.Features.RssTest do
  use PlanetWeb.FeatureCase

  @moduletag :feature
  alias Planet.Core.FeedServer
  import PlanetWeb.Factory
  import Mox

  import Wallaby.Query

  setup :set_mox_global
  setup :verify_on_exit!

  @stub_feed_xml File.read!("test/fixtures/feed_fixture.xml")

  setup do
    feeds = [
      rss_fixture(%{name: "zname", url: "https://zurl.com"}),
      rss_fixture(%{name: "aname", url: "https://aurl.com"}),
      rss_fixture(%{name: "mname", url: "https://murl.com"})
    ]

    FetchMock
    |> Mox.stub(:get, fn _ -> @stub_feed_xml end)

    start_supervised!(FeedServer)

    %{fixtures: feeds}
  end

  test "feeds should be listed in descending order by name", %{
    session: session,
    fixtures: fixtures
  } do
    feeds =
      session
      |> visit("/")
      |> click(Query.link("Feeds"))
      |> find(css("#feedName", count: 3))

    feeds
    |> List.first()
    |> assert_text(Enum.at(fixtures, 1).name)

    feeds
    |> List.last()
    |> assert_text(Enum.at(fixtures, 0).name)
  end

  test "should be able to add an RSS feed", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("Feeds"))
    |> click(Query.link("New"))
    |> fill_in(Query.text_field("Name"), with: "Blog title")
    |> fill_in(Query.text_field("URL"), with: "https://bloggington.blog")
    |> fill_in(Query.text_field("Author"), with: "The Blog Man")
    |> click(Query.button("Add"))
    |> assert_text("Success!")
  end

  test "should be able to update an RSS feed", %{session: session, fixtures: fixtures} do
    session
    |> visit("/")
    |> click(Query.link("Feeds"))
    |> click(Query.link(List.first(fixtures).name))
    |> fill_in(Query.text_field("Name"), with: "New amazing name")
    |> click(Query.button("Update"))
    |> take_screenshot
    |> assert_text("Success!")
  end

  test "should display blog posts on the home page", %{session: session} do
    session
    |> visit("/")
    |> assert_text("Integrate and Deploy React with Phoenix")
  end
end
