---
title: "A Shiny app on Hong Kong District Councillors"

author: "Martin Chan"
date: "September 5, 2020"
layout: post
tags: shiny open-source
image: https://github.com/Hong-Kong-Districts-Info/hong-kong-districts-info.github.io/raw/master/images/DCAppDemo3.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/a-shiny-app-for-hong-kong-district-councillors_20200905_files/header-attrs-2.3/header-attrs.js"></script>
<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/a-shiny-app-for-hong-kong-district-councillors_20200905_files/accessible-code-block-0.0.1/empty-anchor.js"></script>

<section class="main-content">
<div id="tldr" class="section level2">
<h2>👀 TL;DR</h2>
<p>We built an <a href="https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/">R Shiny app</a> to improve access to information on Hong Kong’s local politicians. This is so that voters can make more informed choices. The app shows basic information on each politician, alongside a live feed of their Facebook page and illustrative maps of their district. We took advantage of this project to test out <strong>a range of R packages and techniques</strong> and to <strong>implement some DevOps best practices</strong>, which we will discuss in this post.</p>
<blockquote>
<p><em>This project is an attempt to help make a difference with R programming. It’s an opportunity for us to learn, to code, to have fun, and to make a difference.</em></p>
</blockquote>
<p>This blog post is originally published on <a href="https://martinctc.github.io/blog/" class="uri">https://martinctc.github.io/blog/</a>, and co-authored by Martin Chan and Avision Ho.</p>
</div>
<div id="overview" class="section level2">
<h2>💻 Overview</h2>
<p>Our project was mainly motivated by an observation <strong>that the engagement of the Hong Kong public with their local politicians was very low.</strong><a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> Historically, the work of Hong Kong’s District Councillors (DCs) are neither widely known nor closely scrutinised by the public media. Until recently, most District Councillors did not use webpages or Facebook pages to share their work, but instead favour distributing physical copies of ‘work reports’ via Direct Mail. This has changed significantly with the 2019 District Council election, which was a significant  election where the turnout has jumped to 71% (from 47% in 2015), for different reasons. For context, Hong Kong’s District Councils is the most local level of government, and is the only level in which there is full universal suffrage for all candidates.</p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/18-district-council.png" alt="A map of Hong Kong's 18 District Councils. Illustration by Ocean Cheung" style="max-width:500px;"></p>
<p>As of the summer of 2020, we identified that 96% (434) of the 452 District Councillors elected in 2019 actually have a dedicated Facebook page for delivering updates to and engaging with local residents. However, these Facebook pages have to be manually searched for online, and there is not a readily available tool where people can quickly map a District to a District Councillor and to their Facebook feeds.</p>
<p>As a wise person once said, <em>“If you can solve a problem effectively in R, why the hell not?”</em>. We tackled this problem by creating a Shiny app in R, which brings the Facebook feeds and constituency information for Hong Kong’s district councillors in one place. In this way, people will be able to access the currently disparately stored information in a single web app.</p>
<p>You can access:</p>
<ul>
<li>The Shiny app <a href="https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/">here</a>.</li>
<li>Our GitHub repository <a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors">here</a>.</li>
<li>Don’t forget to also provide some feedback to the Shiny app <a href="https://hkdistrictsinfo.typeform.com/to/gFHC02gE">here</a>!</li>
</ul>
<p>Whether you are more of an R enthusiast or simply someone who has an interest in Hong Kong politics (hopefully both!), we hope this post will bring you some inspiration on how you can use R <em>not just</em> as a great tool for data analysis, but also as an enabler for you to do something tangible for your community and contribute to causes you care about.</p>
</div>
<div id="what-is-in-the-app" class="section level2">
<h2>🔍 What is in the app?</h2>

<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/hkdc-app-example.png" style="max-width:500px;">

<p>The Shiny app is built like a dashboard which combines information about each district councillor alongside their Facebook page posts (if it exists) and the district they serve, illustrated on an interactive map. By using the District and Constituency dropdown lists, you can retrieve information about the District Councillor and their Facebook feed.</p>
<p>Specifically, there are several key components that were used on top of the incredible <a href="https://github.com/rstudio/shiny">shiny</a> package:</p>
<ul>
<li><a href="https://github.com/rstudio/shinydashboard">shinydashboard</a>: For mobile-friendly dashboard layout.
<ul>
<li>We understood that our users, primarily HK citizens, frequently use mobiles. Thus, to ensure this app was useful to them, we centred our design on how the app looked on their mobile browsers.</li>
</ul></li>
</ul>
<ul>
<li><a href="https://github.com/tidyverse/googlesheets4">googlesheets4</a>: For seamless access to Google Sheets. 
<ul>
<li>We understood that our users are not all technical so we stored the core data in a format and platform familiar and accessible to most people, Google Sheets.</li>
<li>At a later stage of the app development, we migrated to storing the data in an R package we wrote, called <a href="https://github.com/hong-Kong-Districts-Info/hkdatasets"><strong>hkdatasets</strong></a> as we sought to keep the data in one place. However, the Google Sheets implementation worked very well, and the app could be deployed with no impact on performance or user experience.</li>
</ul></li>
<li><a href="https://github.com/r-spatial/sf">sf</a> and <a href="https://github.com/rstudio/leaflet">leaflet</a>: For importing geographic data and creating interactive maps.
<ul>
<li>We understood that our users may want to explore other parts of Hong Kong but may not know the names of each constituency. Thus, we provided a map functionality to improve the ease they can learn more about different parts of Hong Kong.</li>
</ul></li>
<li><a href="https://github.com/carlganz/rintrojs">rintrojs</a>: For interactive tutorials.
<ul>
<li>We understood that our users are not necessarily keen to read pages of instructions on how to use the app, especially if they are on mobile. Thus, we implemented a dynamic feature that walks them through visually each component of the app.</li>
</ul></li>
</ul>
</div>
<div id="how-was-the-data-collected" class="section level2">
<h2>🗄️ How was the data collected?</h2>
<p>Since there was no existing single data source on the DCs, we had to put this together ourselves. All the data on each DC, their constituency, the party they belong to, and their Facebook page was all collected manually through a combination of Wikipedia and Facebook. The data was initially housed on Google Sheets, for multiple reasons:</p>
<ol style="list-style-type: decimal">
<li>Using Google Sheets made it easy for multiple people to collaborate on data entry.</li>
<li>Keeping the data outside of the repo has the advantage of keeping the memory size minimal, in line with best practices.</li>
<li>By storing the data in Google Sheets, non-technical users would also be able to access the data too.</li>
</ol>
<p>Most of all, it was easy to access the Google Sheets data with the {googlesheets4} package! For editing the data for <em>pre-processing</em>, a key function is <code>googlesheets4::gs4_auth()</code>, which directs the developer to a web browser, asked to sign in to their Google account, and to grant googlesheets4 permission to operate on their behalf with Google Sheets. We then set up the main Google Sheet - the nicely formatted version intended for the app to ingest - to provide read-only access to anyone with the link, and used <code>googlesheets4::gs4_deauth()</code> to access the public Google Sheet in a <em>de-authorised</em> state. The Shiny app itself does not have any particular Google credentials stored alongside it (which it shouldn’t, for security reasons), and this workflow allows (i) collaborators/developers to edit the data from R and (ii) for the app to access the Google Sheet data without any need for users to login.</p>
<p>This Google Sheet is available <a href="https://docs.google.com/spreadsheets/d/1007RLMHSukSJ5OfCcDJdnJW5QMZyS2P-81fe7utCZwk/">here</a>.</p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/googlesheet-example.png" style="max-width:500px;"></p>
<p>Creating a map with constituency boundaries also required additional data. Boundaries for each constituency were obtained through a Freedom of Information (FOI) request by a member of the public <a href="https://accessinfo.hk/en/request/shapefileshp_for_2019_district_c">here</a> (see discussion of <em>shapefiles</em> below).</p>
<p>This was pretty much Phase #1 of data collection, where we had single Google Sheet with basic information about the District Councillors and their Facebook feeds, which enabled us to create a proof of concept of the Shiny app, i.e. making sure that we can set up a mechanism where the user can select a constituency and the app returns the corresponding Facebook feed of the District Councillor.</p>
<p>Based on user feedback, we started with Phase #2 of data collection, which involved a web-scraping exercise on the official <a href="https://www.districtcouncils.gov.hk/index.html">Hong Kong District Council website</a> and the <a href="https://dce2019.hk01.com/">HK01 News Page on the 2019 District Council elections</a> to get extra data points, such as: - Contact email address - Contact number - Office address - Number of votes, and share of votes won in 2019</p>
<p>A function that was extremely helpful for figuring out the URL of the District Councillors’ individual official pages is the following. What this does is to run a Bing search on the <a href="https://www.districtcouncils.gov.hk" class="uri">https://www.districtcouncils.gov.hk</a> website, and scrape from the search result any links which match what we want (based on what the URL string looks like). Although this doesn’t always work, it helped us a long way with the 452 District Councillors.</p>
<pre><code>scrape_dcs &lt;- function(search_term){

  query_string &lt;- paste(&quot;site: https://www.districtcouncils.gov.hk&quot;, search_term)

  squery &lt;- URLencode(query_string)

  squeryfull &lt;- paste0(&quot;https://www.bing.com/search?q=&quot;, squery)

  main_page &lt;- xml2::read_html(squeryfull)

  temp &lt;- html_nodes(main_page, &#39;.b_title a&#39;) %&gt;%
    html_attr(&quot;href&quot;)

  temp[grepl(&quot;member_id=&quot;, temp)]
}</code></pre>
<p>One key thing to note is that all of the above data we compiled is available and accessible in the public domain, where we simply took an extra step to improve the accessibility.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> The Phase #2 data was used in the final app to provide more information to the user when a particular constituency or District Councillor is selected.</p>
</div>
<div id="creating-a-data-package" class="section level2">
<h2>📦 Creating a data package</h2>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/hkdatasets-hex.png" style="max-width:150px;"></p>
<p>Our data R package, <a href="https://github.com/hong-Kong-Districts-Info/hkdatasets"><strong>hkdatasets</strong></a>, is to some extent a spin-off of this project. We decided to migrate from Google Sheets to an R data package approach, for the following reasons:</p>
<ul>
<li><p>An R data package could allow us to provide more detailed documentation and tracking of how the data would change over time. If we choose to expand the dataset in the future, we can easily add this to the package release notes.</p></li>
<li><p>An R data package would fit well with our broader ambition to work on other Hong Kong themed, open-source projects. From sharing our project with friends, we were approached to help with another project to visualise Hong Kong traffic collisions data, where the repo is <a href="https://github.com/Hong-Kong-Districts-Info/hktrafficcollisions">here</a>. As part of this, we obtained this data via an FOI request on traffic collisions, where the data is also available through <strong>hkdatasets</strong>.</p></li>
<li><p>Make it easier for learners and students in the R community to practise with the datasets we’ve put together, without having to learn about the <strong>googlesheets4</strong> package. Our thinking is that this would benefit others as other data packages like <strong>nycflights13</strong> and <strong>babynames</strong> have benefitted us as we learned R.</p></li>
</ul>
<p><strong>hkdatasets</strong> is currently only available on GitHub, and our aim is to release it on CRAN in the future so that more R users to take advantage of it. Check out our <a href="https://github.com/hong-Kong-Districts-Info/hkdatasets">GitHub repo</a> to find out more about it.</p>
</div>
<div id="linking-our-shiny-app-to-facebook" class="section level2">
<h2>🔗 Linking our Shiny App to Facebook</h2>
<p><img src="https://github.com/Hong-Kong-Districts-Info/hong-kong-districts-info.github.io/raw/master/images/DCAppDemo3.gif" style="max-width:500px;"></p>
<p>When we first conceptualised this project, our aim has always been to make the Facebook Page content the centre piece of the app. This was contingent on using some form of Facebook API to access content on the District Councillors’ Public Pages, which we initially thought would be easy as Public Page content is ‘out there’, and shouldn’t require any additional permissions or approvals.</p>
<p>It turns out, in order to read public posts from Facebook Pages that we do not have admin access to requires a certain permission called <strong>Page Public Content Access</strong>, which in turn requires us to submit our app to Facebook for review. Reading several threads (such as <a href="https://developers.facebook.com/community/threads/385801828797027/">this</a>) online soon convinced us that this would be a fairly challenging process, as we need to effectively submit a proposal on why we had to request this permission. To add to the difficulty, we understood that the App Review process had been put on pause at the time, due to the re-allocation of resourcing during COVID-19.</p>
<p>This drove us to search for a workaround, and this is where we stumbled across <em>iframes</em> as a solution. An <em>iframe</em> is basically a frame that enables you embed a HTML document within another HTML document (they’ve existed for a long time, as I recall using them in the really early GeoCities and Xanga websites).</p>
<p>The <code>iframe</code> concept roughly works as follows. All the Facebook Page URLs are saved in a vector called <code>FacebookURL</code>, and this is “wrapped” with some HTML markup that enables it to be rendered within the Shiny App as an UI component (using <code>shiny::uiOutput()</code>:</p>
<pre><code>chunk1 &lt;- &#39;&lt;iframe src=&quot;https://www.facebook.com/plugins/page.php?href=&#39;
chunk3 &lt;- &#39;&amp;tabs=timeline&amp;width=400&amp;height=800&amp;small_header=false&amp;adapt_container_width=true&amp;hide_cover=false&amp;show_facepile=true&amp;appId=3131730406906292&quot; width=&quot;400&quot; height=&quot;800&quot; style=&quot;border:none;overflow:hidden&quot; scrolling=&quot;no&quot; frameborder=&quot;0&quot; allowTransparency=&quot;true&quot; allow=&quot;encrypted-media&quot;&gt;&lt;/iframe&gt;&#39;
iframe &lt;- paste0(chunk1, FacebookURL, chunk3)</code></pre>
<p>Although the <code>iframe</code> solution comes with its own challenges, such as the difficulty in making it truly responsive / mobile-optimised, it was nonetheless an expedient and effective workaround that allowed us to produce a proof-of-concept; the alternative was to splash around in Facebook’s API documentation and discussion boards for at least another month to achieve the App Approval (bearing in mind that we were working on this in our own free time, with limited resources).</p>
</div>
<div id="visualising-the-shapefiles" class="section level2">
<h2>🌍 Visualising the shapefiles</h2>
<blockquote>
<p>The first rule of optimisation is you don’t.</p>
<p>— <em>Michael A. Jackson</em></p>
</blockquote>
<p>We acquired shapefiles in order to be able to visualise the individual Disticts on a map, which we obtained from <a href="https://accessinfo.hk/en/request/shapefileshp_for_2019_district_c">AccessInfo.HK</a>. A shapefile is, according to <a href="https://desktop.arcgis.com/en/arcmap/10.3/manage-data/shapefiles/what-is-a-shapefile.htm">the ArcGIS website</a>:</p>
<blockquote>
<p>… a simple, nontopological format for storing the geometric location and attribute information of geographic features. Geographic features in a shapefile can be represented by points, lines, or polygons (areas).</p>
</blockquote>
<p>These shapefiles could be easily used as part of a <strong>ggplot2</strong> workflow, which we created with <code>geom_sf()</code> to rapidly get a Proof of Concept. This was to quickly visualise the districts and how they look in relation to the Shiny app.</p>
<p>The code we used was as follows:</p>
<pre><code>map_hk_districts &lt;- ggplot() +
  geom_sf(data = shape_hk, fill = &#39;#009E73&#39;) +
  geom_sf(data = shape_district, fill = &#39;#56B4E9&#39;, alpha = 0.2, linetype = &#39;dotted&#39;, size = 0.2)</code></pre>
<p><img src="https://user-images.githubusercontent.com/25527485/88489291-6891a280-cf8b-11ea-8c0e-eb48a5af5094.png" style="max-width:500px;"> </p>
<p class="caption">(Image shows an earlier iteration of the app)</p>
<p>Once we settled on how the map looked in relation to the Shiny app, we then spent some additional time and effort to investigate using <a href="https://github.com/rstudio/leaflet">leaflet</a>. The reason for moving to <strong>leaflet</strong> maps because of their interactivity: we understood our users would want to explore the HK map interactively to find out what consituency they belong to or to find out one that was of interest. This was because we were aware that people may know what region they live in but they may not know the name of the consituency.</p>
</div>
<div id="what-are-our-next-steps" class="section level2">
<h2>💭 What are our next steps?</h2>
<p>There were some cool features that we would have liked to, but have not been able to implement:</p>
<ul>
<li><a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/17">precommit hooks</a>: Those familiar with Python may be aware of pre-commit hooks as ways to automatically detect whether your repo contains anything sensitive like a <code>.secrets</code> file. Setting this up will enable us to have automated checks run each time we make a commit to assure we are follow specified standards.
<ul>
<li>Unfortunately, we named our repo with a hyphen so the pre-commit hooks won’t work.</li>
<li><a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/33">codecov</a>: Allows us to robustly test the functions in our code so that they work under a multitude of scenarios such as when users encounter problems.</li>
</ul></li>
<li><a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/26">modularise shiny code</a>: Ensures our Shiny code is chunked so individual pieces of logic are isolated.
<ul>
<li>This makes the overall code easier to follow as it separates the objects that are connected from those that are not. It also makes testing easier because you can test each isolated chunk.</li>
</ul></li>
<li><a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/36">language selection</a>: Currently the app is a smorgasbord of English and Chinese. Consequently, it looks messy. We want to implement the ability for the user to choose which language they want to see the app in and the app’s language will update accordingly.</li>
<li>Release to alpha testers to get early feedback.</li>
<li>More of our enhancements / spikes are listed here on <a href="https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues">GitHub</a></li>
</ul>
<p>One of the things that we wanted to try out with this open-source project is to adhere to some DevOps best practices, yet unfortunately some of these were either easier to set up from the beginning, or require more time and knowledge (on our part) to set up. As we develop a V2 of this Shiny App and work on <a href="https://hong-kong-districts-info.github.io/portfolio/">other projects</a>, we hope to find the opportunity to implement more of the above features.</p>
</div>
<div id="other-features-in-the-app" class="section level2">
<h2>🔥 Other features in the app</h2>
<p>There were also a number of features that we have implemented, but were not detailed in this post. For instance:</p>
<ul>
<li>Adding a searchable DataTable with information on the District Councillors, with the <strong>DT</strong> package</li>
<li>Embedding a user survey within the Shiny app</li>
<li>Adding a tutorial to go through features of the Shiny app, using the <strong>rintrojs</strong> package</li>
<li>Adding loader animations with <strong>shinycssloaders</strong></li>
</ul>
<p>We will cover more of that detail in a Part 2 of this blog, so watch this space!</p>
</div>
<div id="who-is-behind-this" class="section level2">
<h2>💪 Who is behind this?</h2>
<p>Multiple people contributed to this work. <strong>Avision Ho</strong> is a data scientist who wrote the majority of the Shiny app, and who was also <a href="https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/">previously interviewed on this blog</a>. Avision is a co-author on this post. <strong>Ocean Cheung</strong> came up with the original idea of this app, and made it all possible with his knowledge and network with District Councillors. We would also like to credit <strong>Justin Yim</strong>, <strong>Tiffany Chau</strong>, and <strong>Gabriel Tam</strong> for their feedback and advice on the scope and the direction of this app. We are currently working on a number of other projects, which you can find out more from our website: <a href="https://hong-kong-districts-info.github.io/" class="uri">https://hong-kong-districts-info.github.io/</a>.</p>
<p>(Disclaimer! We are not affiliated to any political individuals nor movements. We are simply some people who’d like to contribute to society through code and open-source projects.)</p>
</div>
<div id="want-to-get-involved" class="section level2">
<h2>✋ Want to get involved?</h2>
<p>We’re looking for collaborators or reviewers, so please send us an email (<a href="mailto:hkdistricts.info@gmail.com" class="email">hkdistricts.info@gmail.com</a>), or comment down below if you are interested! We would also appreciate any feedback or questions, which you could either comment below or respond to our <a href="https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/">in-app survey</a>. You can also get an idea of things we are planning to work on through our Trello board <a href="https://trello.com/b/n5l7DMS5/doing">here</a>.</p>
<p>When we first started out, we were just a couple of people who wanted to learn and practise a new skill (e.g. building a Shiny app, implementing best practices), and wanted a meaningful open-source project that we could work on. Read more about <a href="https://hong-kong-districts-info.github.io/about/">our Vision Statement here</a>.</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>There are many reasons for this, and arguably a similar phenomenon can be observed in most local elections in other countries. See Lee, F. L., &amp; Chan, J. M. (2008). Making sense of participation: The political culture of pro-democracy demonstrators in Hong Kong. <em>The China Quarterly</em>, 84-101.<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
<li id="fn2"><p>This is in compliance with the ICO’s description of the ‘public domain’, i.e. that <em>information is only in the public domain if it is realistically accessible to a member of the general public at the time of the request. It must be available in practice, not just in theory</em>.<a href="#fnref2" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>