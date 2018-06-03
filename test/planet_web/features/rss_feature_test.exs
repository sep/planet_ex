defmodule PlanetWeb.Features.RssTest do
  use PlanetWeb.FeatureCase, async: true
  import PlanetWeb.Factory

  import Wallaby.Query

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
end
