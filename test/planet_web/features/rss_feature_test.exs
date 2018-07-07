defmodule PlanetWeb.Features.RssTest do
  use PlanetWeb.FeatureCase

  @moduletag :feature
  alias Planet.Core.FeedServer
  import PlanetWeb.Support
  import Mox

  import Wallaby.Query

  setup :set_mox_global
  setup :verify_on_exit!

  describe "feeds page" do
    setup do
      feeds = [
        rss_fixture(%{name: "zname", url: "https://zurl.com"}),
        rss_fixture(%{name: "aname", url: "https://aurl.com"}),
        rss_fixture(%{name: "mname", url: "https://murl.com"})
      ]

      FetchMock
      |> Mox.stub(:get, fn _ -> feed_fixture() end)

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
      |> assert_text("Success!")
    end
  end

  describe "entries page" do
    setup do
      rss_fixture(%{name: "aname", url: "https://aurl.com"})
      stub_feed_xml = feed_fixture(15)

      FetchMock
      |> Mox.stub(:get, fn _ -> stub_feed_xml end)

      start_supervised!(FeedServer)

      :ok
    end

    test "should display blog posts on the home page", %{session: session} do
      session
      |> visit("/")
      |> assert_text("Integrate and Deploy React with Phoenix")
    end

    test "should paginate blog posts", %{session: session} do
      article_count =
        session
        |> visit("/")
        |> all(css("article"))
        |> Enum.count()

      assert article_count == 10
    end

    test "should display second page of blog posts", %{session: session} do
      article_count =
        session
        |> visit("/")
        |> refute_has(link("Prev"))
        |> click(link("Next"))
        |> refute_has(link("Next"))
        |> all(css("article"))
        |> Enum.count()

      assert article_count == 5
    end
  end
end
