defmodule PlanetExWeb.Support do
  @moduledoc """
  This module contains test fixtures and other helpful support functions for use during test and development.
  """
  @valid_attrs %{author: "some author", name: "some name", url: "some url", is_sharepoint: false}

  def feed_fixture(attrs \\ %{}) do
    {:ok, rss} =
      attrs
      |> Enum.into(@valid_attrs)
      |> PlanetEx.Feeds.create_rss()

    rss
  end

  def atom_fixture(authors, count \\ 1) do
    author = Keyword.get(authors, :author, "Mitchell Hanberg")
    entry_author = Keyword.get(authors, :entry, author)

    beginning = """
    <?xml version="1.0" encoding="utf-8"?>
      <feed xmlns="http://www.w3.org/2005/Atom" >
      <generator uri="https://jekyllrb.com/" version="3.7.3">Jekyll</generator>
      <link href="https://www.blog.com/feed.xml" rel="self" type="application/atom+xml" />
      <link href="https://www.blog.com/" rel="alternate" type="text/html" />
      <updated>2018-06-03T22:29:43+00:00</updated>
      <id>unique_id1234</id>
      <title type="html">Blog's Blog</title>
      <author>
        <name>#{author}</name>
      </author>
    """

    relative_link = "&lt;a href=&quot;/relativelink&quot;&gt;create-react-app&lt;/a&gt;"
    relative_img = "&lt;img src=&quot;/images/contact.png&quot; alt=&quot;&quot; /&gt;"

    entry = """
    <entry><title type="html">Blog title</title><link href="https://www.blog.com/path/to/blog/" rel="alternate" type="text/html" title="Blog title" /><published>2018-02-22T12:00:00+00:00</published><updated>2018-02-22T12:00:00+00:00</updated><id>https://www.blog.com/path/to/blog</id><content type="html" xml:base="https://www.blog.com/path/to/blog/">&lt;blockquote&gt;
    &lt;p&gt;You’ve just finished your lightning fast Phoenix JSON API, what’s next?&lt;/p&gt;
    &lt;/blockquote&gt;

    &lt;h2 id=&quot;motivation&quot;&gt;Motivation&lt;/h2&gt;

    &lt;p&gt;#{relative_img}&lt;/p&gt;

    &lt;p&gt;My most recent side project, #{relative_link}, is a JSON REST API written with &lt;a href=&quot;https://elixir-lang.org/&quot;&gt;Elixir&lt;/a&gt; and &lt;a href=&quot;https://github.com/phoenixframework/phoenix&quot;&gt;Phoenix&lt;/a&gt;, designed to be the backend to an instant messaging application (e.g., Slack). There was a hackathon coming up at work, and I thought it’d be fun to make a frontend for Contact during it, and although Contact’s development was thoroughly test-driven, I wanted to make sure that my API was ready to be used.&lt;/p&gt;
    </content>
    <author>
    <name>#{entry_author}</name>
    </author>
    </entry>
    """

    ehnd = ~s(</feed>)

    beginning <> String.duplicate(entry, count) <> ehnd
  end

  def feature_fixture(authors, count \\ 1) do
    author = Keyword.get(authors, :author, "Mitchell Hanberg")
    entry_author = Keyword.get(authors, :entry, author)

    beginning = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" >
    <generator uri="https://jekyllrb.com/" version="3.7.3">Jekyll</generator>
    <link href="https://www.blog.com/feed.xml" rel="self" type="application/atom+xml" />
    <link href="https://www.blog.com/" rel="alternate" type="text/html" />
    <updated>2018-06-03T22:29:43+00:00</updated>
    <id>https://www.blog.com/</id>
    <title type="html">Blogs Blog</title>
    <author><name>#{author}</name></author>
    """

    entry = """
    <entry><title type="html">Blog Post title</title><link href="https://www.blog.com/path/to/post/" rel="alternate" type="text/html" title="Blog Post title" /><published>2018-02-22T12:00:00+00:00</published><updated>2018-02-22T12:00:00+00:00</updated><id>https://www.blog.com/path/to/post/</id><content type="html" xml:base="https://www.blog.com/path/to/post/">

    &lt;p&gt;This is a blog post!&lt;/p&gt;

    </content>
    <author>
    <name>#{entry_author}</name>
    </author>
    </entry>
    """

    ehnd = ~s(</feed>)

    beginning <> String.duplicate(entry, count) <> ehnd
  end

  def rss_fixture(count \\ 1) do
    beginning = """
    <?xml version="1.0" encoding="UTF-8"?><rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
    >

    <channel>
    <title>SEP Blog</title>
    <atom:link href="https://www.sep.com/sep-blog/feed/" rel="self" type="application/rss+xml" />
    <link>https://www.sep.com/sep-blog</link>
    <description>Featured Posts From SEPeers</description>
    <lastBuildDate>Fri, 29 Jun 2018 19:18:53 +0000</lastBuildDate>
    <language>en-US</language>
    <sy:updatePeriod>hourly</sy:updatePeriod>
    <sy:updateFrequency>1</sy:updateFrequency>
    """

    item = """
    <item>
    <title>Blog title</title>
    <link>https://www.sep.com/sep-blog/path/to/blog/</link>
    <pubDate>Tue, 19 Jun 2018 15:53:03 +0000</pubDate>
    <dc:creator><![CDATA[SEPeer]]></dc:creator>
    <category><![CDATA[Please change category to your name]]></category>
    <category><![CDATA[SEPeers]]></category>

    <guid isPermaLink="false">http://www.sep.com/sep-blog/?p=xxx</guid>
    <description><![CDATA[This is the description of an item in an RSS feed...]]></description>
    <content:encoded><![CDATA[<h3><img class="wp-image-9576 alignleft" src="http://www.sep.com/sep-blog/path/to/image.png" alt="" width="153" height="177" /><p>This is the content of this blog post</p>]]></content:encoded>
    </item>
    """

    ehnd = "</channel></rss>"

    beginning <> String.duplicate(item, count) <> ehnd
  end

  def rss_fixture_only_description(count \\ 1) do
    beginning = """
    <?xml version="1.0" encoding="UTF-8"?><rss version="2.0"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
    >

    <channel>
    <title>SEP Blog</title>
    <atom:link href="https://www.sep.com/sep-blog/feed/" rel="self" type="application/rss+xml" />
    <link>https://www.sep.com/sep-blog</link>
    <description>Featured Posts From SEPeers</description>
    <lastBuildDate>Fri, 29 Jun 2018 19:18:53 +0000</lastBuildDate>
    <language>en-US</language>
    <sy:updatePeriod>hourly</sy:updatePeriod>
    <sy:updateFrequency>1</sy:updateFrequency>
    """

    item = """
    <item>
    <title>Blog title</title>
    <link>http://blog.com/path/to/post/</link>
    <pubDate>Published on Fri, 30 Dec 2016 16:25:00 +0000</pubDate>
    <guid isPermaLink="false">ID 2016-12-30T16:25:00 on http://blog.com</guid>
    <description>&lt;p&gt;This is the body of this blog post&lt;/p&gt;</description>
    </item>
    """

    ehnd = "</channel></rss>"

    beginning <> String.duplicate(item, count) <> ehnd
  end

  def sharepoint_fixture do
    """
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" id="HtmlRootTag" dir="ltr"><!--?xml version="1.0" encoding="UTF-8"?--><!--RSS generated by Microsoft SharePoint Foundation RSS Generator on 7/29/2018 11:24:18 AM --><!--?xml-stylesheet type="text/xsl" href="/personal/path/to/blog" version="1.0"?--><head></head><body><rss version="2.0">
    <channel>
    <title>Blog: Posts</title>
    <link />https://blog.com/path/to/blog
    <description>RSS feed for the Posts list.</description>
    <lastbuilddate>Sun, 29 Jul 2018 15:24:18 GMT</lastbuilddate>
    <generator>Microsoft SharePoint Foundation RSS Generator</generator>
    <ttl>60</ttl>
    <language>en-US</language>
    <img />
    <title>Blog: Posts</title>
    <url>https://blog.com/path/to/image.png</url>
    <link />https://blog.com/path/to/blog

    <item>
    <title>Blog title</title>
    <link />https://blog.com/post
    <description><!--[CDATA[<div--><b>Body:</b> <div><p>This is the body of the blog post.</p></div>
    <div><b>Published:</b> 7/3/2018 11:03 AM</div>
    ]]&gt;</description>
    <author>Blog Author</author>
    <pubdate>Tue, 03 Jul 2018 15:07:18 GMT</pubdate>
    <guid ispermalink="true">https://blog.com/post</guid>
    </item>
    </channel>
    </rss></body></html>
    """
  end

  def pry(passthrough) do
    require IEx
    # credo:disable-for-next-line
    IEx.pry()

    passthrough
  end
end
