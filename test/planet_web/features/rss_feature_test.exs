defmodule PlanetExWeb.Features.RssTest do
  use PlanetExWeb.FeatureCase

  @moduletag :feature
  alias PlanetEx.Core.ServerFarmSupervisor
  import PlanetExWeb.Support

  import Wallaby.Query

  describe "feeds page" do
    setup do
      feeds = [
        feed_fixture(%{name: "zname", url: "https://zurl.com"}),
        feed_fixture(%{name: "aname", url: "https://aurl.com"}),
        feed_fixture(%{name: "mname", url: "https://murl.com"})
      ]

      FetchMock
      |> Mox.stub(:get, fn _ -> feature_fixture(author: "Mitchell Hanberg") end)

      start_supervised!(ServerFarmSupervisor)

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

    test "should be able to add a sharepoint RSS feed", %{session: session} do
      session
      |> visit("/")
      |> click(Query.link("Feeds"))
      |> click(Query.link("New"))
      |> fill_in(Query.text_field("Name"), with: "Blog title")
      |> fill_in(Query.text_field("URL"), with: "https://bloggington.blog")
      |> fill_in(Query.text_field("Author"), with: "The Blog Man")
      |> click(Query.checkbox("Sharepoint?"))
      |> click(Query.button("Add"))
      |> assert_text("Success!")
    end

    test "should be able to update an RSS feed", %{session: session, fixtures: fixtures} do
      feed = List.first(fixtures)

      session
      |> visit("/")
      |> click(Query.link("Feeds"))
      |> click(Query.button("btn-#{feed.id}"))
      |> click(Query.link("Edit"))
      |> fill_in(Query.text_field("Name"), with: "New amazing name")
      |> click(Query.button("Update"))
      |> assert_text("Success!")
    end

    test "should be able to delete an RSS feed", %{session: session, fixtures: fixtures} do
      feed = List.first(fixtures)

      session
      |> visit("/")
      |> click(Query.link("Feeds"))
      |> click(Query.button("btn-#{feed.id}"))
      |> accept_confirm(fn s ->
        s |> click(Query.link("Delete"))
      end)

      session
      |> assert_text("Success!")
    end
  end
end
