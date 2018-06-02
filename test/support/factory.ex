defmodule PlanetWeb.Factory do
  @valid_attrs %{author: "some author", name: "some name", url: "some url"}

  def rss_fixture(attrs \\ %{}) do
    {:ok, rss} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Planet.Feeds.create_rss()

    rss
  end
end
