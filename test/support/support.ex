defmodule PlanetWeb.Support do
  @valid_attrs %{author: "some author", name: "some name", url: "some url", is_sharepoint: false}

  def feed_fixture(attrs \\ %{}) do
    {:ok, rss} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Planet.Feeds.create_rss()

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

    &lt;p&gt;The hackathon was two weeks away, so I needed to quickly prototype a UI to flesh out any oversights I made.&lt;/p&gt;

    &lt;p&gt;I decided to go with React over basic server-rendered html templates because my next project at work will be using React and figured I could use this to level up my skills.&lt;/p&gt;

    &lt;h2 id=&quot;lets-add-react&quot;&gt;Let’s add React!&lt;/h2&gt;

    &lt;p&gt;If you generated your Phoenix project using the &lt;code class=&quot;highlighter-rouge&quot;&gt;mix phx.new --no-html --no-brunch&lt;/code&gt; command, you’re good to go!&lt;/p&gt;

    &lt;p&gt;If not, let’s rip out the stock html and Javascript scaffolding that Phoenix generates for you. You can safely remove the &lt;code class=&quot;highlighter-rouge&quot;&gt;priv/assets&lt;/code&gt; directory (which contains all of the Brunch configuration) and &lt;code class=&quot;highlighter-rouge&quot;&gt;lib/&amp;lt;path to your web directory&amp;gt;/templates&lt;/code&gt;, along with any Phoenix views, controllers, and routes that you aren’t using.&lt;/p&gt;

    &lt;p&gt;A good place to install our React app is the &lt;code class=&quot;highlighter-rouge&quot;&gt;priv&lt;/code&gt; directory, so let’s move into there and run the installer.&lt;/p&gt;

    &lt;div class=&quot;language-shell highlighter-rouge&quot;&gt;&lt;div class=&quot;highlight&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;c&quot;&gt;# priv/&lt;/span&gt;
    &lt;span class=&quot;nv&quot;&gt;$ &lt;/span&gt;npx create-react-app contact-react 
    &lt;span class=&quot;nv&quot;&gt;$ &lt;/span&gt;&lt;span class=&quot;nb&quot;&gt;cd &lt;/span&gt;contact-react 
    &lt;span class=&quot;nv&quot;&gt;$ &lt;/span&gt;yarn start &lt;span class=&quot;c&quot;&gt;# npm start if you don't use yarn&lt;/span&gt;
    &lt;/code&gt;&lt;/pre&gt;&lt;/div&gt;&lt;/div&gt;

    &lt;p&gt;&lt;a href=&quot;https://github.com/facebook/create-react-app&quot;&gt;create-react-app&lt;/a&gt; gets us set up with React, Babel, and Webpack out of the box, allowing us to get started developing our application and not mess around with a ton of esoteric configuration.&lt;/p&gt;

    &lt;h2 id=&quot;success&quot;&gt;Success!&lt;/h2&gt;

    &lt;p&gt;We now have a development server running, serving the generated React application.&lt;/p&gt;

    &lt;p&gt;&lt;img src=&quot;https://www.mitchellhanberg.com/images/create-react-default.png&quot; alt=&quot;&quot; /&gt;&lt;/p&gt;

    &lt;h2 id=&quot;connecting-the-frontend-to-the-backend&quot;&gt;Connecting the frontend to the backend&lt;/h2&gt;

    &lt;p&gt;You may have noticed that your Phoenix server and the React development server are running on two different ports, how can we allow our two applications to communicate with each other?&lt;/p&gt;

    &lt;h3 id=&quot;development&quot;&gt;Development&lt;/h3&gt;

    &lt;p&gt;We’ll set up a proxy for development, so we won’t have to specify the absolute URI of the API endpoints we want to hit. Let’s add this line to our &lt;code class=&quot;highlighter-rouge&quot;&gt;package.json&lt;/code&gt;.&lt;/p&gt;

    &lt;div class=&quot;language-json highlighter-rouge&quot;&gt;&lt;div class=&quot;highlight&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;s2&quot;&gt;&quot;proxy&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;:&lt;/span&gt;&lt;span class=&quot;w&quot;&gt; &lt;/span&gt;&lt;span class=&quot;s2&quot;&gt;&quot;http://localhost:4000&quot;&lt;/span&gt;&lt;span class=&quot;w&quot;&gt;
    &lt;/span&gt;&lt;/code&gt;&lt;/pre&gt;&lt;/div&gt;&lt;/div&gt;

    &lt;p&gt;This line will set all network request URIs to be made relative to our Phoenix server.&lt;/p&gt;

    &lt;h3 id=&quot;production&quot;&gt;Production&lt;/h3&gt;

    &lt;p&gt;In production, we’ll have the Phoenix server send the frontend to the client.&lt;/p&gt;

    &lt;p&gt;To accomplish this, we’ll set up the root endpoint to serve the contents of the &lt;code class=&quot;highlighter-rouge&quot;&gt;build&lt;/code&gt; directory of our React app.&lt;/p&gt;

    &lt;div class=&quot;language-elixir highlighter-rouge&quot;&gt;&lt;div class=&quot;highlight&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;c1&quot;&gt;# endpoint.ex&lt;/span&gt;

    &lt;span class=&quot;n&quot;&gt;plug&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;&lt;span class=&quot;no&quot;&gt;Plug&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;no&quot;&gt;Static&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;no&quot;&gt;IndexHtml&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt; &lt;span class=&quot;ss&quot;&gt;at:&lt;/span&gt; &lt;span class=&quot;sd&quot;&gt;&quot;&lt;/span&gt;&lt;span class=&quot;s2&quot;&gt;/&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;
    &lt;span class=&quot;n&quot;&gt;plug&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;(&lt;/span&gt;
    &lt;span class=&quot;no&quot;&gt;Plug&lt;/span&gt;&lt;span class=&quot;o&quot;&gt;.&lt;/span&gt;&lt;span class=&quot;no&quot;&gt;Static&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;
    &lt;span class=&quot;ss&quot;&gt;at:&lt;/span&gt; &lt;span class=&quot;sd&quot;&gt;&quot;&lt;/span&gt;&lt;span class=&quot;s2&quot;&gt;/&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;
    &lt;span class=&quot;ss&quot;&gt;from:&lt;/span&gt; &lt;span class=&quot;sd&quot;&gt;&quot;&lt;/span&gt;&lt;span class=&quot;s2&quot;&gt;priv/contact-react/build/&quot;&lt;/span&gt;&lt;span class=&quot;p&quot;&gt;,&lt;/span&gt;
    &lt;span class=&quot;ss&quot;&gt;only:&lt;/span&gt; &lt;span class=&quot;sx&quot;&gt;~w(index.html favicon.ico static service-worker.js)&lt;/span&gt;
    &lt;span class=&quot;p&quot;&gt;)&lt;/span&gt;
    &lt;/code&gt;&lt;/pre&gt;&lt;/div&gt;&lt;/div&gt;

    &lt;p&gt;&lt;a href=&quot;https://hex.pm/packages/plug_static_index_html&quot;&gt;&lt;code class=&quot;highlighter-rouge&quot;&gt;Plug.Static.IndexHtml&lt;/code&gt;&lt;/a&gt; will allow us to serve the &lt;code class=&quot;highlighter-rouge&quot;&gt;index.html&lt;/code&gt; that Webpack generates from the root endpoint.&lt;/p&gt;

    &lt;p&gt;Now if we run &lt;code class=&quot;highlighter-rouge&quot;&gt;yarn build&lt;/code&gt;, start our Phoenix server, and navigate to &lt;code class=&quot;highlighter-rouge&quot;&gt;localhost:4000&lt;/code&gt; in the browser, we should see our React application!&lt;/p&gt;

    &lt;h2 id=&quot;deployment&quot;&gt;Deployment&lt;/h2&gt;

    &lt;p&gt;Since we have added another build step to our workflow, we’ll need to include that in our deployment process. I will describe the steps needed to deploy using &lt;a href=&quot;https://travis-ci.org/&quot;&gt;Travis CI&lt;/a&gt;.&lt;/p&gt;

    &lt;p&gt;I added a &lt;code class=&quot;highlighter-rouge&quot;&gt;before_deploy&lt;/code&gt; step and set the &lt;code class=&quot;highlighter-rouge&quot;&gt;skip_cleanup&lt;/code&gt; flag to the &lt;code class=&quot;highlighter-rouge&quot;&gt;deploy&lt;/code&gt; step to my &lt;code class=&quot;highlighter-rouge&quot;&gt;.travis.yml&lt;/code&gt; file, resembling the following.&lt;/p&gt;

    &lt;div class=&quot;language-yaml highlighter-rouge&quot;&gt;&lt;div class=&quot;highlight&quot;&gt;&lt;pre class=&quot;highlight&quot;&gt;&lt;code&gt;&lt;span class=&quot;na&quot;&gt;before_deploy&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt;
    &lt;span class=&quot;pi&quot;&gt;-&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;rm -rf ~/.nvm &amp;amp;&amp;amp; curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash &amp;amp;&amp;amp; nvm install node &amp;amp;&amp;amp; nvm use node&lt;/span&gt;
    &lt;span class=&quot;pi&quot;&gt;-&lt;/span&gt; &lt;span class=&quot;s&quot;&gt;cd priv/contact-react &amp;amp;&amp;amp; yarn install &amp;amp;&amp;amp; yarn build &amp;amp;&amp;amp; cd -&lt;/span&gt; 
    &lt;span class=&quot;na&quot;&gt;deploy&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt;
    &lt;span class=&quot;na&quot;&gt;skip_cleanup&lt;/span&gt;&lt;span class=&quot;pi&quot;&gt;:&lt;/span&gt; &lt;span class=&quot;no&quot;&gt;true&lt;/span&gt;
    &lt;/code&gt;&lt;/pre&gt;&lt;/div&gt;&lt;/div&gt;

    &lt;p&gt;A breakdown of what is happening here:&lt;/p&gt;

    &lt;ul&gt;
    &lt;li&gt;Reinstall the latest version of &lt;a href=&quot;https://github.com/creationix/nvm&quot;&gt;Node Version Manager&lt;/a&gt;.&lt;/li&gt;
    &lt;li&gt;Install the latest version of Node.js.&lt;/li&gt;
    &lt;li&gt;Set the current version of Node.js to the one we just installed.&lt;/li&gt;
    &lt;li&gt;Build our React application (Yarn is already installed).&lt;/li&gt;
    &lt;li&gt;Tell Travis to deploy the compiled React application (otherwise, Travis would see the &lt;code class=&quot;highlighter-rouge&quot;&gt;build&lt;/code&gt; directory as a build artifact and clean it up before deployment).&lt;/li&gt;
    &lt;/ul&gt;

    &lt;h2 id=&quot;its-time-to-get-to-work&quot;&gt;It’s time to get to work!&lt;/h2&gt;

    &lt;p&gt;In 10 minutes we’ve gone from nothing to a deployed application!&lt;/p&gt;

    &lt;p&gt;Following these steps allowed me to get right to business; I was successful in prototyping 90% of my application before the hackathon.&lt;/p&gt;

    &lt;hr /&gt;

    &lt;h4 id=&quot;references&quot;&gt;References&lt;/h4&gt;

    &lt;ul&gt;
    &lt;li&gt;&lt;a href=&quot;http://www.petecorey.com/blog/2017/04/03/using-create-react-app-with-phoenix/&quot;&gt;http://www.petecorey.com/blog/2017/04/03/using-create-react-app-with-phoenix/&lt;/a&gt;&lt;/li&gt;
    &lt;li&gt;&lt;a href=&quot;https://docs.travis-ci.com/user/deployment/heroku/#Deploying-build-artifacts&quot;&gt;https://docs.travis-ci.com/user/deployment/heroku/#Deploying-build-artifacts&lt;/a&gt;&lt;/li&gt;
    &lt;li&gt;&lt;a href=&quot;https://docs.travis-ci.com/user/deployment/heroku/#Running-commands-before-and-after-deploy&quot;&gt;https://docs.travis-ci.com/user/deployment/heroku/#Running-commands-before-and-after-deploy&lt;/a&gt;&lt;/li&gt;
    &lt;/ul&gt;
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
    <h3><img class="wp-image-9577 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/kiana-caston-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/kiana-caston-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/kiana-caston-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Kiana Caston</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>Rose-Hulman Institute of Technology</p>
    <p><strong>Major:</strong> Computer Science and Software Engineering</p>
    <p>&#8220;I chose to work at SEP this summer because it was an opportunity to work at a small company that was good at what they do. I also like the employee culture and the various opportunities.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9578 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/aneta-ciepiela-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/aneta-ciepiela-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/aneta-ciepiela-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Aneta Ciepiela</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>Rose-Hulman Institute of Technology</p>
    <p><strong>Major:</strong> Computer Science</p>
    <p>&#8220;I chose to work at SEP because I really liked how the culture was very collaborative, and everyone seemed passionate about learning new things and having fun.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="alignleft wp-image-9579" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/frank-coppola-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/frank-coppola-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/frank-coppola-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Frank Coppola</strong></h3>

    <p><strong>School: </strong>Indiana University (Bloomington)</p>
    <p><strong>Major:</strong> Finance and Business Analytics</p>
    <p>&#8220;I chose to work at SEP because I wanted to gain experience working on the business operations side of  the software industry, the most innovative type of product/service in today&#8217;s modern business world.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9580 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/torin-edwards-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/torin-edwards-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/torin-edwards-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Torin Edwards</strong></h3>
    <p><em>Design Intern</em></p>
    <p><strong>School: </strong>University of North Carolina at Chapel Hill</p>
    <p><strong>Major:</strong> Media &amp; Journalism and Information Science</p>
    <p>&#8220;I chose SEP for a lot of reasons, but the biggest one was that I wanted to go somewhere where I was given the opportunity to grow professionally by gaining hands-on experience.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9595 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/michael-Hewner-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/michael-Hewner-blog-post.png 283w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/michael-Hewner-blog-post-261x300.png 261w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Michael Hewner</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>Rose-Hulman Institute of Technology</p>
    <p><strong>Major:</strong> Computer Science and Software Engineering</p>
    <p>&#8220;The friendly environment, good project management, and a strong focus on improving technical skills.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9581 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/yvonee-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/yvonee-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/yvonee-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Yvonne Lumetta</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>Rose-Hulman Institute of Technology</p>
    <p><strong>Major:</strong> Computer Engineering</p>
    <p>&#8220;I saw the company at my school&#8217;s career fair during my freshmen year and was bombarded with good reviews for the next three years by other students who worked here, so I decided to apply.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9582 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/josh-martin-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/josh-martin-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/josh-martin-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Josh Martin</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>IUPUI</p>
    <p><strong>Major:</strong> Computer Engineering</p>
    <p>&#8220;I have been to SEP a few times, and I have met a lot of people here and I think the biggest pull for me to want to work at SEP was the culture. Everyone holds a growth mindset and treats others with respect.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9583 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/nick-myers-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/nick-myers-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/nick-myers-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Nick Myers</strong></h3>
    <p><em>Business Intern</em></p>
    <p><strong>School: </strong>Indiana University (Bloomington)</p>
    <p><strong>Major:</strong> Entrepreneurship and Corporate Innovation</p>
    <p>&#8220;I decided to intern with SEP this summer, because I&#8217;m able to work on a software product that fits with my love for entrepreneurship.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9584 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/luke-pell-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/luke-pell-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/luke-pell-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Luke Pell</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>IUPUI</p>
    <p><strong>Major:</strong> Computer Engineering</p>
    <p>&#8220;I chose to work at SEP this summer because of the collaborative culture and the ability to expand my software engineering experience.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9585 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/indhu-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/indhu-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/indhu-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Indhu Meena Ramanathan</strong></h3>
    <p><em>Software Engineering Intern</em></p>
    <p><strong>School: </strong>Purdue University</p>
    <p><strong>Major:</strong> Computer Science</p>
    <p>&#8220;I chose to work at SEP this summer because I value learning new things and working with others to solve problems. I wanted to work in an environment in which I could learn about the field and the workplace.&#8221;</p>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    <h3><img class="wp-image-9586 alignleft" src="http://www.sep.com/sep-blog/wp-content/uploads/2018/06/lianne-yu-blog-post.png" alt="" width="154" height="177" srcset="https://www.sep.com/sep-blog/wp-content/uploads/2018/06/lianne-yu-blog-post.png 266w, https://www.sep.com/sep-blog/wp-content/uploads/2018/06/lianne-yu-blog-post-262x300.png 262w" sizes="(max-width: 154px) 100vw, 154px" /><strong>Lianne Yu</strong></h3>
    <p><em>Business Intern</em></p>
    <p><strong>School: </strong>Indiana University (Bloomington)</p>
    <p><strong>Major:</strong> Finance and Business Analytics</p>
    <p>&#8220;I was excited to join a company with so many employees of diverse backgrounds and skills, and I wanted to learn more about an industry that&#8217;s expanding more and more quickly.&#8221;</p>
    ]]></content:encoded>
    </item>
    """

    ehnd = "</channel></rss>"

    beginning <> String.duplicate(item, count) <> ehnd
  end

  def sharepoint_fixture() do
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
    IEx.pry()

    passthrough
  end
end
