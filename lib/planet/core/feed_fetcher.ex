defmodule Planet.Core.FeedFetcher do
  alias Planet.Core.FeedParser.Feed

  @callback get(url :: String.t()) :: %Feed{}
  def get(url) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, response} ->
        response.body

      {:error, _r} ->
        ""
    end
  end
end
