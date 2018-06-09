defmodule PlanetWeb.RssView do
  use PlanetWeb, :view

  def last_updated_at(feed) do
    feed.entries
    |> List.first()
    |> Map.get(:published, Timex.now())
    |> Timex.format!("{M}/{D}/{YYYY}")
  end

  def published(datetime), do: Timex.format!(datetime, "{ISO:Extended}")

  def escape(text) do
    text
    |> html_escape
    |> safe_to_string
  end
end
