defmodule PlanetWeb.Router do
  use PlanetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlanetWeb do
    pipe_through :browser

    get "/", EntriesController, :index
    resources "/rss", RssController
  end
end
