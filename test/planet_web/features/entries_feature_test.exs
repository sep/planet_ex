defmodule PlanetExWeb.Features.EntriesTest do
  use PlanetExWeb.FeatureCase

  @moduletag :feature
  alias PlanetEx.Core.ServerFarmSupervisor
  import PlanetExWeb.Support

  import Wallaby.Query

  describe "entries page" do
    setup do
      feed_fixture(%{name: "aname", url: "https://aurl.com"})
      stub_feed_xml = feature_fixture([author: "Mitchell Hanberg"], 15)

      FetchMock
      |> Mox.stub(:get, fn _ -> stub_feed_xml end)

      start_supervised!(ServerFarmSupervisor)

      :ok
    end

    test "should display blog posts on the home page", %{session: session} do
      session
      |> visit("/")
      |> assert_text("Blog Post title")
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
