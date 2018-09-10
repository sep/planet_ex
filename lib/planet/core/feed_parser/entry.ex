defmodule Planet.Core.FeedParser.Entry do
  @moduledoc """
  This module represents an Entry, an item in a Feed.
  """
  defstruct [:title, :url, :author, :content, :published]

  def convert_relative_urls(content, url) do
    content
    |> String.replace(~r{(href|src)=(?:"|')/(.*?)(?:"|')}, "\\1=\"#{url}\\2\"")
  end
end
