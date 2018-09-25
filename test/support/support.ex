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
    <link href="https://www.mitchellhanberg.com/feed.xml" rel="self" type="application/atom+xml" />
    <link href="https://www.mitchellhanberg.com/" rel="alternate" type="text/html" />
    <updated>2018-06-03T22:29:43+00:00</updated>
    <id>https://www.mitchellhanberg.com/</id>
    <title type="html">Mitchell Hanberg’s Blog</title>
    <author><name>#{author}</name>
    </author>
    """

    relative_link = "&lt;a href=&quot;/relativelink&quot;&gt;create-react-app&lt;/a&gt;"
    relative_img = "&lt;img src=&quot;/images/contact.png&quot; alt=&quot;&quot; /&gt;"

    entry = """
    <entry><title type="html">Integrate and Deploy React with Phoenix</title><link href="https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix/" rel="alternate" type="text/html" title="Integrate and Deploy React with Phoenix" /><published>2018-02-22T12:00:00+00:00</published><updated>2018-02-22T12:00:00+00:00</updated><id>https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix</id><content type="html" xml:base="https://www.mitchellhanberg.com/post/2018/02/22/integrate-and-deploy-react-with-phoenix/">&lt;blockquote&gt;
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
    <title>Meet the 2018 Interns</title>
    <link>https://www.sep.com/sep-blog/2018/06/19/meet-the-2018-interns/</link>
    <pubDate>Tue, 19 Jun 2018 15:53:03 +0000</pubDate>
    <dc:creator><![CDATA[SEP Interns]]></dc:creator>
    <category><![CDATA[Please change category to your name]]></category>
    <category><![CDATA[SEP Interns]]></category>

    <guid isPermaLink="false">http://www.sep.com/sep-blog/?p=9574</guid>
    <description><![CDATA[Ahmed Ali Software Engineering Intern School: University of California Berkley Major: Electronic Engineering and Computer Science &#8220;SEP explained they wanted to match me with a project that lasts throughout the...]]></description>
    <content:encoded><![CDATA[<h3><img class="wp-image-9576 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/ahmed-ali-blog-post.png" alt="" width="153" height="177" /><strong>Ahmed Ali</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>University of California Berkley</p>
    <p><strong>Major:</strong> Electronic Engineering and Computer Science</p>
    <p>&#8220;SEP explained they wanted to match me with a project that lasts throughout the internship. From that moment, I realized that this company actually cares about its interns and gives me mentorship.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    ]]></content:encoded>
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
    <title>Optimize for cognitive load</title>
    <link>http://arktronic.com/weblog/2016-12-30/optimize-for-cognitive-load/</link>
    <pubDate>Published on Fri, 30 Dec 2016 16:25:00 +0000</pubDate>
    <guid isPermaLink="false">ID 2016-12-30T16:25:00 on http://arktronic.com</guid>
    <description>&lt;p&gt;I recently read a rather interesting post by Martin Fowler regarding &lt;a href=&quot;http://martinfowler.com/bliki/FunctionLength.html&quot;&gt;function length&lt;/a&gt;, where he suggested that very small functions that encompass the implementation for a single intention are ideal. I have a somewhat different view of this argument, which also happens to touch on larger concerns of software design and even, to a certain extent, architecture. It is a holistic view, in the sense that the same goal is desired at multiple levels, from the function to the entire system.&lt;/p&gt;
    &lt;p&gt;I urge you to keep the human factors dicussed here in mind when performing any task from the writing of functions to the design of systems. While different goals may take precedence at different times, simply keeping these concerns in mind will allow you to create better software.&lt;/p&gt;</description>
    </item>
    """

    ehnd = "</channel></rss>"

    beginning <> String.duplicate(item, count) <> ehnd
  end

  def sharepoint_fixture do
    """
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:dc="http://purl.org/dc/elements/1.1/" id="HtmlRootTag" dir="ltr"><!--?xml version="1.0" encoding="UTF-8"?--><!--RSS generated by Microsoft SharePoint Foundation RSS Generator on 7/29/2018 11:24:18 AM --><!--?xml-stylesheet type="text/xsl" href="/personal/ohri/Blog/_layouts/15/RssXslt.aspx?List=cc026f11-42a9-481a-92a4-03608256b2f1" version="1.0"?--><head></head><body><rss version="2.0">
    <channel>
    <title>Blog: Posts</title>
    <link />https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/AllPosts.aspx
    <description>RSS feed for the Posts list.</description>
    <lastbuilddate>Sun, 29 Jul 2018 15:24:18 GMT</lastbuilddate>
    <generator>Microsoft SharePoint Foundation RSS Generator</generator>
    <ttl>60</ttl>
    <language>en-US</language>
    <img />
    <title>Blog: Posts</title>
    <url>https://sharepoint.sep.com:8383/personal/ohri/Blog/_layouts/15/images/siteIcon.png</url>
    <link />https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/AllPosts.aspx

    <item>
    <title>Staffing Meeting Notes 7/3/18</title>
    <link />https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/ViewPost.aspx?ID=400
    <description><!--[CDATA[<div--><b>Body:</b> <div class="ExternalClass8E387C3D4A3B497E84470A1B4BECD791"><p>JML – RRC (Rolls-Royce Corporation) still hasn't signed off for the T4 Extension.  Ada<br /></p><p>CRT – Reviewed and signed Dealer Channel SOW (Statement Of Work) from Deere.  Waiting for counter-signed copy.<br /></p><p>KLP – Sent RRC quote for KMS (Knowledge Management System) CI (Continuous Integration) / CD (Continuous Deployment) Pipeline in Azure.  Azure<br /></p><p>KLP – Sent RRC quote for EHMS (Engine Health Monitoring System) Flight Processing Change. RR still trying to talk the Air Force out of this.<br /></p><p>JML – Talking with Ascension on Thursday about intermediate development support.  Will also be discussing longer term support.<br /></p><p>JML – Working on support plan for AACCEE (Automated Analysis of Customer Configured Engines &amp; Equipment) for RRC.  Their contact is out all week, so we'll touch base next week.</p><p>JML – Good meeting with Crown about IMM (Information Management Module) v2. Exploring architecture work under new working model.<br /></p><p>JML – Will contact RRC about Test Cell UMACS (Universal Monitor and Control System) Development.  Qt, QNX</p><p>RMS – We have verbal with DK Pierce.  Need to figure out how to quote it.</p><p>JML – Continuing discussions with RRC about GMT (Ground Maintenance Terminal) SPL (Software Product Line) (EaaS). Looking to do a prototype to show them what's possible.</p><p>KLP – Will discuss FY (Fiscal Year) 19 work for Agronauts team with Deere mid-July.</p><p>JML – Integrated Partners (worked with them for Ascension) has some other work.  Will discuss by mid-July.</p><p>CRT – Will be discussing FY19 work with Deere in the next few weeks.</p><p>ARS – Meeting next week with Martin Brothers.  Looking for development help.  React, Java, Mobile</p><p>ARS – AMB Surgical has an application that they want a mobile version developed.  Meeting with them next year.  First step will be rough order of magnitude estimate.</p><p>JML – We're conducting a proactive internal audit of the Lilly work, looking at the PSA (Professional Services Agreement), Quality Agreement, Security Agreement.  Hope this will be a template that can be used for other clients in the future.  Discussion of doing more frequent project checks rather than focusing it all annually prior to the ISO audit.</p></div>
    <div><b>Published:</b> 7/3/2018 11:03 AM</div>
    ]]&gt;</description>
    <author>Raman N. Ohri</author>
    <pubdate>Tue, 03 Jul 2018 15:07:18 GMT</pubdate>
    <guid ispermalink="true">https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/ViewPost.aspx?ID=400</guid>
    </item>
    <item>
    <title>Staffing Meeting Notes 6/26/18</title>
    <link />https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/ViewPost.aspx?ID=399
    <description><!--[CDATA[<div--><b>Body:</b> <div class="ExternalClass9EC13A54D4FE485FBB9D61B2FDA38848"><p>JML – Still waiting for PO (Purchase Order) from RRC (Rolls-Royce Corporation) for T4 Extension.  Ada<br /></p><p>CMA – Talked with Allegion last week about them needing a team.  They have a meeting this Thursday when they should get more clarity.  I'll follow up after that.​<br /></p><p>CRT – Expecting SOW from Deere for Dealer Channel work.  Java, React, Redux.<br /></p><p>JML – Small amount of work available (2 weeks) from TCS (Time Compression Strategies) for continuing database work.<br /></p><p>KLP – Proposing KMS (Knowledge Management System) CI (Continuous Integration) / CD (Continuous Deployment) Pipeline in Azure to RRC this week.<br /></p><p>RMS – Will propose to Beckman Coulter an Azure Architecture Review.<br /></p><p>JML – Putting together a proposal to help support Ascension until they're ready for the next phase.<br /></p><p>JML – Working on planning for support of AACCEE (Automated Analysis of Customer Configured Engines &amp; Equipment) for 3Q work.  .NET core, Python<br /></p><p>KLP – Proposing EHMS Flight Processing Change this week with RRC.  Web, Oracle, Perl, C#, Javascript<br /></p><p>JML – Met yesterday with Crown.  Real opportunity to help out again.  They seem to be sold on the practices we were asking for.  Will be proposing an approach after some internal discussions.<br /></p></div>
    <div><b>Published:</b> 7/2/2018 4:21 PM</div>
    ]]&gt;</description>
    <author>Raman N. Ohri</author>
    <pubdate>Mon, 02 Jul 2018 20:22:48 GMT</pubdate>
    <guid ispermalink="true">https://sharepoint.sep.com:8383/personal/ohri/Blog/Lists/Posts/ViewPost.aspx?ID=399</guid>
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
