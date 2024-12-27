---
title: "Vignette: Scraping Amazon Reviews in R"

author: "Martin Chan"
date: "May 16, 2019"
layout: post
tags: vignettes r rvest
image: http://martinctc.github.io/blog/images/amazon_got.PNG
---

<section class="main-content">
<div id="background" class="section level2">
<h2>Background</h2>
<p>One of the pet projects that I had been working on earlier in the year was to figure out an efficient way to gain an insight into what is going on in a consumer market, e.g.:</p>
<ul>
<li>What do people look for when they’re buying a product?</li>
<li>What are the typical pain points / causes of frustration in the purchase process or in a product itself?</li>
</ul>
<p>There are many ways to do this: usage and attitude surveys, qualitative focus groups, online bulletin-board style platform, social media mining, etc. But most of these methods take a lot of time and cost to set up, and may not be suitable if you’re trying to have a quick glimpse of what’s happening.</p>
<p><strong>Amazon reviews</strong> provide a fast, accessible yet vast data resource that does both of these things, allowing you to quickly explore what’s going on at effectively zero data collection cost. In this blog post, I’ll go through some examples of how all this could be done in R with relatively few lines of code.</p>
<p><strong>Note</strong> : As a data collection activity, web-scraping may have legal implications depending on your country. For the UK, as a general rule you can legally web-scrape anything out there that is in the public domain, but it is recommended that you obtain the site owner’s permission if you are reporting on the data or using the data for commercial use (See this <a href="https://benbernardblog.com/web-scraping-and-crawling-are-perfectly-legal-right/">post</a> for a more in-depth discussion)</p>
<hr />
</div>
<div id="getting-started" class="section level2">
<h2>Getting Started 🚀</h2>
<p>The first step is to load the <strong>tidyverse</strong> and <strong>rvest</strong> packages, as we’ll need them for building the webscraping function (e.g. parsing html) and for general data manipulation:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(tidyverse)<span class="kw">
library</span>(rvest)</code></pre></div>
<p>The next step is to find out the <em>ASIN</em> (stands for Amazon Standard Identification Number) of the product that you want to extract reviews from. This is effectively a product ID, which can usually be found within the URL of the product link itself. ASINS are unique strings of 10 characters, where for books this would be the same as the ISBN number.</p>
<p>For our example, let’s use the seven volume paperback collection of George R R Martin’s <em>A Song of Ice and Fire</em>, which has almost 2.5K reviews on Amazon.co.uk at the time of writing. We can also specify the number of review pages to scrape, where the fixed number of reviews per page is ten. In this example, the ASIN is <code>0007477155</code>, and you can find the link to the product by combining the ASIN with “<a href="https://www.amazon.co.uk/dp/" class="uri">https://www.amazon.co.uk/dp/</a>”:</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\amazon_got.PNG" width="80%" /></p>
<p>To my knowledge, the URL structure works the same way for Amazon US and Amazon UK - you can simply change the URL root to make this work for the different websites (replace ‘.co.uk’ with ‘.com’). Whether this will continue to work in the future will be dependent on whether Amazon changes the set-up of the URLs.</p>
<hr />
</div>
<div id="writing-the-review-scraping-function" class="section level2">
<h2>Writing the review scraping function</h2>
<p>The next step is to write the main workhorse function for scraping the reviews.</p>
<p>In essence, what we are trying to achieve is to download the HTML content from the Amazon review page, and then use various html parsing and selector functions to organise the downloaded content into an easily manipulable format.</p>
<p>The <code>read_html()</code> function from the <strong>xml2</strong> package reads the HTML content from a given URL, which you can assign to an object in R (so you don’t have to keep re-downloading the website) and figure out how to extract content from the object.</p>
<p>In this specific example of scraping Amazon reviews, our objective is to get to a table that has the following three basic columns:</p>
<ul>
<li>Title of the Review</li>
<li>Body / Content of the Review</li>
<li>Rating given for the Review</li>
</ul>
<p>The trick is to use a combination of <code>html_nodes()</code> and <code>html_text()</code> from the <strong>rvest</strong> package to lock onto the content that you need (The <strong>rvest</strong> package recommends <a href="http://flukeout.github.io/">this</a> really cool site for learning how to use CSS selectors).</p>
<p>In my function, I assign all the bits of extracted content (review title, review body text, and star rating) into individual objects, and combine them into a tidy tibble to make it easy for data analysis.</p>
<p>Let’s call this function <code>scrape_amazon()</code>, and allow it to take in the ASIN and the page number as the two arguments:</p>

<div class="sourceCode" id="cb2">
<pre class="sourceCode r">
<code class="sourceCode r">
<span class="sourceLine" id="cb2-1" title="1">scrape_amazon &lt;-<span class="st"> </span><span class="cf">function</span>(ASIN, page_num){</span>
<span class="sourceLine" id="cb2-2" title="2">  </span>
<span class="sourceLine" id="cb2-3" title="3">  url_reviews &lt;-<span class="st"> </span><span class="kw">paste0</span>(<span class="st">&quot;https://www.amazon.co.uk/product-reviews/&quot;</span>,ASIN,<span class="st">&quot;/?pageNumber=&quot;</span>,page_num)</span>
<span class="sourceLine" id="cb2-4" title="4">  </span>
<span class="sourceLine" id="cb2-5" title="5">  doc &lt;-<span class="st"> </span><span class="kw">read_html</span>(url_reviews) <span class="co"># Assign results to `doc`</span></span>
<span class="sourceLine" id="cb2-6" title="6">  </span>
<span class="sourceLine" id="cb2-7" title="7">  <span class="co"># Review Title</span></span>
<span class="sourceLine" id="cb2-8" title="8">  doc <span class="op">%&gt;%</span><span class="st"> </span></span>
<span class="sourceLine" id="cb2-9" title="9"><span class="st">    </span><span class="kw">html_nodes</span>(<span class="st">&quot;[class=&#39;a-size-base a-link-normal review-title a-color-base review-title-content a-text-bold&#39;]&quot;</span>) <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb2-10" title="10"><span class="st">    </span><span class="kw">html_text</span>() -&gt;<span class="st"> </span>review_title</span>
<span class="sourceLine" id="cb2-11" title="11">  </span>
<span class="sourceLine" id="cb2-12" title="12">  <span class="co"># Review Text</span></span>
<span class="sourceLine" id="cb2-13" title="13">  doc <span class="op">%&gt;%</span><span class="st"> </span></span>
<span class="sourceLine" id="cb2-14" title="14"><span class="st">    </span><span class="kw">html_nodes</span>(<span class="st">&quot;[class=&#39;a-size-base review-text review-text-content&#39;]&quot;</span>) <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb2-15" title="15"><span class="st">    </span><span class="kw">html_text</span>() -&gt;<span class="st"> </span>review_text</span>
<span class="sourceLine" id="cb2-16" title="16">  </span>
<span class="sourceLine" id="cb2-17" title="17">  <span class="co"># Number of stars in review</span></span>
<span class="sourceLine" id="cb2-18" title="18">  doc <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb2-19" title="19"><span class="st">    </span><span class="kw">html_nodes</span>(<span class="st">&quot;[data-hook=&#39;review-star-rating&#39;]&quot;</span>) <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb2-20" title="20"><span class="st">    </span><span class="kw">html_text</span>() -&gt;<span class="st"> </span>review_star</span>
<span class="sourceLine" id="cb2-21" title="21">  </span>
<span class="sourceLine" id="cb2-22" title="22">  <span class="co"># Return a tibble</span></span>
<span class="sourceLine" id="cb2-23" title="23">  <span class="kw">tibble</span>(review_title,</span>
<span class="sourceLine" id="cb2-24" title="24">         review_text,</span>
<span class="sourceLine" id="cb2-25" title="25">         review_star,</span>
<span class="sourceLine" id="cb2-26" title="26">         <span class="dt">page =</span> page_num) <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">return</span>()</span>
<span class="sourceLine" id="cb2-27" title="27">}</span></code></pre></div>
<p>You can then run this function to extract a nice, clean table of reviews:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb3-1" title="1"><span class="kw">scrape_amazon</span>(<span class="dt">ASIN =</span> <span class="st">&quot;0007477155&quot;</span>, <span class="dt">page_num =</span> <span class="dv">5</span>) <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb3-2" title="2"><span class="st">  </span><span class="kw">head</span>()</span></code></pre></div>


<pre><code>## # A tibble: 6 x 4
##   review_title                review_text                review_star   page
##   &lt;chr&gt;                       &lt;chr&gt;                      &lt;chr&gt;        &lt;dbl&gt;
## 1 &quot;Fantastic!\n        &quot;      &quot;Absolutely loved the ser~ 5.0 out of ~     5
## 2 &quot;Brilliant audio books\n  ~ &quot;Delivered well packaged ~ 5.0 out of ~     5
## 3 &quot;Epic!\n        &quot;           &quot;I don&#39;t normally read mu~ 4.0 out of ~     5
## 4 &quot;At 2,000 pages plus I am ~ &quot;I have two confessions t~ 4.0 out of ~     5
## 5 &quot;Great value for a good co~ &quot;I bought &#39;Game of Throne~ 5.0 out of ~     5
## 6 &quot;everybody who has read or~ &quot;Well, everybody who has ~ 5.0 out of ~     5</code></pre>
<hr />
</div>
<div id="avoiding-bot-detection" class="section level2">
<h2>Avoiding bot detection</h2>
<p>Now that we’ve written the main web scraping function, we can add in some complexity: specifically, we can introduce systematic delays in between the HTML reads to avoid overloading web servers in a short space of time, which at the same time also helps avoid yourself being picked up as ‘suspicious webscraping behaviour’.</p>
<p>There are three parts to this anti-bot-detection charade:</p>
<ol style="list-style-type: decimal">
<li>You can instruct R to take a three second break between each HTML read by using the <code>Sys.sleep()</code> function.</li>
<li>You can use the modulus operator <code>%%</code> to get R to take extra long breaks every x number of scrapes (to make this appear even less suspicious for a bot detector).</li>
<li>The third and final part to this is that you can also create a system where you scrape a sequence of pages in <em>random</em> order - e.g. instead of scraping pages 1 - 2 - 3, you can scrape in the order of 2 - 3 - 1.</li>
</ol>
<p><strong>Confession</strong>: I’m personally not 100% sure how useful or necessary all this is in avoiding bot detection (<strong>#rstatsuperstition</strong>), but I tend to include these measures anyway as they’re quite simple and fun to do…</p>
<p>After you’ve set this all up, you can use <code>lapply()</code> to loop through the page ranges:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb5-1" title="1">ASIN &lt;-<span class="st"> &quot;0007477155&quot;</span> <span class="co"># Specify ASIN</span></a>
<a class="sourceLine" id="cb5-2" title="2">page_range &lt;-<span class="st"> </span><span class="dv">1</span><span class="op">:</span><span class="dv">10</span> <span class="co"># Let&#39;s say we want to scrape pages 1 to 10</span></a>
<a class="sourceLine" id="cb5-3" title="3"></a>
<a class="sourceLine" id="cb5-4" title="4"><span class="co"># Create a table that scrambles page numbers using `sample()`</span></a>
<a class="sourceLine" id="cb5-5" title="5"><span class="co"># For randomising page reads!</span></a>
<a class="sourceLine" id="cb5-6" title="6">match_key &lt;-<span class="st"> </span><span class="kw">tibble</span>(<span class="dt">n =</span> page_range,</a>
<a class="sourceLine" id="cb5-7" title="7">                    <span class="dt">key =</span> <span class="kw">sample</span>(page_range,<span class="kw">length</span>(page_range)))</a>
<a class="sourceLine" id="cb5-8" title="8"></a>
<a class="sourceLine" id="cb5-9" title="9"><span class="kw">lapply</span>(page_range, <span class="cf">function</span>(i){</a>
<a class="sourceLine" id="cb5-10" title="10">  j &lt;-<span class="st"> </span>match_key[match_key<span class="op">$</span>n<span class="op">==</span>i,]<span class="op">$</span>key</a>
<a class="sourceLine" id="cb5-11" title="11"></a>
<a class="sourceLine" id="cb5-12" title="12">  <span class="kw">message</span>(<span class="st">&quot;Getting page &quot;</span>,i, <span class="st">&quot; of &quot;</span>,<span class="kw">length</span>(page_range), <span class="st">&quot;; Actual: page &quot;</span>,j) <span class="co"># Progress bar</span></a>
<a class="sourceLine" id="cb5-13" title="13"></a>
<a class="sourceLine" id="cb5-14" title="14">  <span class="kw">Sys.sleep</span>(<span class="dv">3</span>) <span class="co"># Take a three second break</span></a>
<a class="sourceLine" id="cb5-15" title="15"></a>
<a class="sourceLine" id="cb5-16" title="16">  <span class="cf">if</span>((i <span class="op">%%</span><span class="st"> </span><span class="dv">3</span>) <span class="op">==</span><span class="st"> </span><span class="dv">0</span>){ <span class="co"># After every three scrapes... take another two second break</span></a>
<a class="sourceLine" id="cb5-17" title="17">    </a>
<a class="sourceLine" id="cb5-18" title="18">    <span class="kw">message</span>(<span class="st">&quot;Taking a break...&quot;</span>) <span class="co"># Prints a &#39;taking a break&#39; message on your console</span></a>
<a class="sourceLine" id="cb5-19" title="19">    </a>
<a class="sourceLine" id="cb5-20" title="20">    <span class="kw">Sys.sleep</span>(<span class="dv">2</span>) <span class="co"># Take an additional two second break</span></a>
<a class="sourceLine" id="cb5-21" title="21">  }</a>
<a class="sourceLine" id="cb5-22" title="22">  <span class="kw">scrape_amazon</span>(<span class="dt">ASIN =</span> ASIN, <span class="dt">page_num =</span> j) <span class="co"># Scrape</span></a>
<a class="sourceLine" id="cb5-23" title="23">}) -&gt;<span class="st"> </span>output_list</a></code></pre></div>
<p>My R console looks like this, with the progress message: <img src="{{ site.url }}{{ site.baseurl }}\images\amazon_console.PNG" width="80%" /> —</p>
</div>
<div id="what-do-i-do-with-the-results" class="section level2">
<h2>What do I do with the results?</h2>
<p>The analytical possibilities are quite endless: word clouds, n-gram analysis, sentiment analysis, network diagrams… and definitely a topic for a separate post. To end the post, here is a quick demo of what you can easily do with ten lines of code!</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1"><span class="kw">library</span>(tidytext)</a>
<a class="sourceLine" id="cb6-2" title="2"><span class="kw">library</span>(wordcloud)</a>
<a class="sourceLine" id="cb6-3" title="3"></a>
<a class="sourceLine" id="cb6-4" title="4">output_list <span class="op">%&gt;%</span><span class="st"> </span></a>
<a class="sourceLine" id="cb6-5" title="5"><span class="st">  </span><span class="kw">bind_rows</span>() <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb6-6" title="6"><span class="st">  </span><span class="kw">unnest_tokens</span>(<span class="dt">output =</span> <span class="st">&quot;word&quot;</span>, <span class="dt">input =</span> <span class="st">&quot;review_text&quot;</span>, <span class="dt">token =</span> <span class="st">&quot;words&quot;</span>) <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb6-7" title="7"><span class="st">  </span><span class="kw">count</span>(word) <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb6-8" title="8"><span class="st">  </span><span class="kw">filter</span>(<span class="op">!</span>(word <span class="op">%in%</span><span class="st"> </span><span class="kw">c</span>(<span class="st">&quot;book&quot;</span>,<span class="st">&quot;books&quot;</span>))) <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb6-9" title="9"><span class="st">  </span><span class="kw">anti_join</span>(tidytext<span class="op">::</span>stop_words, <span class="dt">by =</span> <span class="st">&quot;word&quot;</span>) -&gt;<span class="st"> </span>word_tb</a>
<a class="sourceLine" id="cb6-10" title="10"></a>
<a class="sourceLine" id="cb6-11" title="11">wordcloud<span class="op">::</span><span class="kw">wordcloud</span>(<span class="dt">words =</span> word_tb<span class="op">$</span>word, <span class="dt">freq =</span> word_tb<span class="op">$</span>n)</a></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/Webscraping_Amazon_16-05-19_files/figure-html/wordcloud-1.png" /><!-- --></p>
</div>
</section>
