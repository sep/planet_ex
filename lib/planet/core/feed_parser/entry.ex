defmodule Planet.Core.FeedParser.Entry do
  @moduledoc """
  This module represents an Entry, an item in a Feed.
  """
  defstruct [:title, :url, :author, :content, :published]
end
