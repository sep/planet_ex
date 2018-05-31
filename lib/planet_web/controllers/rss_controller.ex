defmodule PlanetWeb.RssController do
  use PlanetWeb, :controller
  alias Planet.Feeds.Rss

  def create conn, params = %{"name" => name, "url" => url, "name" => name} do
    with {:ok, %Rss{}} <- Planet.Feeds.create_rss(params) do
      conn
      |> put_status(201)
      |> render(:new)
    end
  end

  def new(conn, _p) do
    render conn, :new
  end
end
