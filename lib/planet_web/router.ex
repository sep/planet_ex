defmodule PlanetExWeb.Router do
  use PlanetExWeb, :router

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

  scope "/", PlanetExWeb do
    pipe_through :browser

    get "/", EntriesController, :index
    resources "/rss", RssController
    resources "/planets", PlanetController, only: [:edit, :update]
  end
end
