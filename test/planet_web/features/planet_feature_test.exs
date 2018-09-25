defmodule PlanetExWeb.Features.PlanetExTest do
  use PlanetExWeb.FeatureCase

  @moduletag :feature
  alias PlanetEx.Core.ServerFarmSupervisor
  import PlanetExWeb.Support

  import Wallaby.Query

  describe "Our Planet page" do
    setup do
      FetchMock
      |> Mox.stub(:get, fn _ -> feature_fixture(author: "Mitchell Hanberg") end)

      start_supervised!(ServerFarmSupervisor)

      :ok
    end

    test "successfully updating Our Planet takes you to the homepage", %{session: session} do
      session =
        session
        |> visit("/")
        |> click(Query.link("Our Planet"))
        |> fill_in(Query.text_field("Title"), with: "New Blog title")
        |> fill_in(Query.text_field("URL"), with: "https://validurl.com")
        |> click(Query.button("Update"))

      session
      |> assert_text("Success!")

      session
      |> assert_text("New Blog title")
    end
  end
end
