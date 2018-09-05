defmodule PlanetWeb.RssController do
  use PlanetWeb, :controller
  alias Planet.Feeds.Rss

  def index(conn, _p) do
    with feeds <- Planet.Feeds.list_rss() |> Enum.sort_by(fn f -> f.name end) do
      conn
      |> render(:index, feeds: feeds)
    end
  end

  def create conn, %{"rss" => params} do
    with {:ok, feed = %Rss{}} <- Planet.Feeds.create_rss(params),
         Planet.Core.FeedStore.store(feed) do
      conn
      |> put_status(303)
      |> put_flash(:success, "You've add the feed #{feed.url}")
      |> redirect(to: "/rss/new")
    else
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render_form(:new, changeset)
    end
  end

  def new(conn, _p) do
    render_form(conn, :new, %Rss{})
  end

  def edit(conn, %{"id" => id}) do
    with feed = %Rss{} <- Planet.Feeds.get_rss!(id) do
      conn
      |> render_form(:edit, feed)
    end
  end

  def update(conn, %{"id" => id, "rss" => params}) do
    feed = Planet.Feeds.get_rss!(id)

    with {:ok, updated_feed = %Rss{}} <- Planet.Feeds.update_rss(feed, params),
         Planet.Core.FeedStore.update(updated_feed) do
      conn
      |> put_status(303)
      |> put_flash(:success, "You've updated the feed #{updated_feed.name}")
      |> redirect(to: "/rss")
    else
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render_form(:edit, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Rss{} = feed <- Planet.Feeds.get_rss(id),
         {:ok, deleted_feed} <- Planet.Feeds.delete_rss(feed),
         Planet.Core.FeedStore.remove(deleted_feed) do
      conn
      |> put_status(303)
      |> put_flash(:success, "You've deleted the feed #{deleted_feed.name}")
      |> redirect(to: "/rss")
    else
      _ ->
        conn
        |> put_status(303)
        |> put_flash(:danger, "Failed to delete that feed!")
        |> redirect(to: "/rss")
    end
  end

  defp render_form(conn, action, rss) do
    rss_changeset = Rss.changeset(rss)

    render conn, action, rss_changeset: rss_changeset
  end
end
