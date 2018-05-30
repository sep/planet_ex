defmodule Planet.FeedsTest do
  use Planet.DataCase

  alias Planet.Feeds

  describe "rss" do
    alias Planet.Feeds.Rss

    @valid_attrs %{author: "some author", name: "some name", url: "some url"}
    @update_attrs %{
      author: "some updated author",
      name: "some updated name",
      url: "some updated url"
    }
    @invalid_attrs %{author: nil, name: nil, url: nil}

    def rss_fixture(attrs \\ %{}) do
      {:ok, rss} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Feeds.create_rss()

      rss
    end

    test "list_rss/0 returns all rss" do
      rss = rss_fixture()
      assert Feeds.list_rss() == [rss]
    end

    test "get_rss!/1 returns the rss with given id" do
      rss = rss_fixture()
      assert Feeds.get_rss!(rss.id) == rss
    end

    test "create_rss/1 with valid data creates a rss" do
      assert {:ok, %Rss{} = rss} = Feeds.create_rss(@valid_attrs)
      assert rss.author == "some author"
      assert rss.name == "some name"
      assert rss.url == "some url"
    end

    test "create_rss/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feeds.create_rss(@invalid_attrs)
    end

    test "update_rss/2 with valid data updates the rss" do
      rss = rss_fixture()
      assert {:ok, rss} = Feeds.update_rss(rss, @update_attrs)
      assert %Rss{} = rss
      assert rss.author == "some updated author"
      assert rss.name == "some updated name"
      assert rss.url == "some updated url"
    end

    test "update_rss/2 with invalid data returns error changeset" do
      rss = rss_fixture()
      assert {:error, %Ecto.Changeset{}} = Feeds.update_rss(rss, @invalid_attrs)
      assert rss == Feeds.get_rss!(rss.id)
    end

    test "delete_rss/1 deletes the rss" do
      rss = rss_fixture()
      assert {:ok, %Rss{}} = Feeds.delete_rss(rss)
      assert_raise Ecto.NoResultsError, fn -> Feeds.get_rss!(rss.id) end
    end

    test "change_rss/1 returns a rss changeset" do
      rss = rss_fixture()
      assert %Ecto.Changeset{} = Feeds.change_rss(rss)
    end
  end
end
