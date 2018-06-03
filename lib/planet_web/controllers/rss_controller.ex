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
    with {:ok, feed = %Rss{}} <- Planet.Feeds.create_rss(params) do
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

  defp render_form(conn, action, rss) do
    rss_changeset = Rss.changeset(rss)

    render conn, action, rss_changeset: rss_changeset
  end
end
