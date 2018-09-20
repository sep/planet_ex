defmodule Planet.Core.FeedFetcher do
  @moduledoc """
  This module is responsible for for fetching Feed data.
  """
  require Logger
  alias Planet.Feeds.Rss
  use Wallaby.DSL

  @callback get(rss :: %Rss{}) :: String.t()
  def get(%Rss{is_sharepoint: false, url: url}) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, response} ->
        response.body

      {:error, _r} ->
        ""
    end
  end

  def get(%Rss{is_sharepoint: true, url: url}) do
    match = Regex.named_captures(~r{(?<protocol>http://|https://)(?<sharepoint_url>.*)}, url)

    url_with_creds =
      match["protocol"] <> System.get_env("SHAREPOINT_CREDS") <> "@" <> match["sharepoint_url"]

    try do
      {:ok, session} = Wallaby.start_session()

      feed =
        session
        |> visit(url_with_creds)
        |> execute_script("""
        fetch("#{url}")
          .then(r => r.text())
          .then(t => document.querySelector("html").innerHTML = t);
        """)
        |> page_source

      session
      |> Wallaby.end_session()

      feed
    rescue
      e ->
        Logger.error("Error fetching sharepoint feed: #{inspect e}")

        ""
    end
  end
end
