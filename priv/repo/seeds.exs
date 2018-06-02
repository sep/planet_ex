~w(
  mitchellhanberg.com
  sep.com
  robots.thoughtbot.com
  spin.atomicobject.com
  engineering.github.com
)
|> Enum.with_index()
|> Enum.each(fn {url, index} ->
  Planet.Feeds.create_rss(%{
    name: "name #{index}",
    url: url,
    author: "author: #{index}"
  })
end)
