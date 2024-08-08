---
title: "Vignette: Google Trends with the gtrendsR package"

author: "Martin Chan"
date: "October 18, 2019"
layout: post
tags: vignettes r
image: https://liberty4hk.github.io/img/music/glory-to-hk.jpg
---


<section class="main-content">
<div id="background" class="section level2">
<h2>Background</h2>
<p><a href="https://trends.google.com">Google Trends</a> is a well-known, free tool provided by Google that allows you to analyse the popularity of top search queries on its Google search engine. In <em>market exploration</em> work, we often use Google Trends to get a very quick view of what behaviours, language, and general things are trending in a market.</p>
<blockquote>
<p>And of course, if you can do something in R, then why not do it in R?</p>
</blockquote>
<p>Philippe Massicotte’s <a href="https://github.com/PMassicotte/gtrendsR">gtrendsR</a> is pretty much the go-to package for running Google Trends queries in R. It’s simple, you don’t need to set up API keys or anything, and it’s fairly intuitive. Let’s have a go at this with a simple and recent example.</p>
</div>
<div id="example-a-controversial-song-from-hong-kong" class="section level2">
<h2>Example: A Controversial Song from Hong Kong</h2>
<p><img src="https://liberty4hk.github.io/img/music/glory-to-hk.jpg"></p>
<p><em>Glory to Hong Kong</em> (Chinese: <em>願榮光歸香港</em>) is a Cantonese march song which became highly controversial politically, due to its wide adoption as the <a href="https://www.youtube.com/watch?v=dY_hkbVQA20">“anthem”</a> of the Hong Kong protests. Since it was written collaboratively by netizens in August 2019,<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> the piece has become viral and was performed all over the world and translated into many different languages.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> It’s also available on <a href="https://open.spotify.com/album/0o0tKVV8rtkDjydBjx7h6S">Spotify</a> - just to give you a bit of context of its popularity.</p>
<p>Analytically, it would be interesting to compare the Google search trends of the English search term (“Glory to Hong Kong”) and the Chinese search term (“願榮光歸香港”), and see what they yield respectively. When did it go viral, and which search term is more popular? Let’s find out.</p>
</div>
<div id="using-gtrendsr" class="section level2">
<h2>Using gtrendsR</h2>
<p><a href="https://github.com/PMassicotte/gtrendsR">gtrendsR</a> is available on CRAN, so just make sure it’s installed (<code>install.packages("gtrendsR")</code>) and load it. Let’s load <strong>tidyverse</strong> as well, which we’ll need for the basic data cleaning and plotting:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb1-1" title="1"><span class="kw">library</span>(gtrendsR)</span>
<span class="sourceLine" id="cb1-2" title="2"><span class="kw">library</span>(tidyverse)</span></code></pre></div>
<p>The next step then is to assign our search terms to a character variable called <code>search_terms</code>, and then use the package’s main function <code>gtrends()</code>.</p>
<p>Let’s set the <code>geo</code> argument to Hong Kong only, and limit the search period to 12 months prior to today. We’ll assign the output to a variable - and let’s call it <code>output_results</code>.</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb2-1" title="1">search_terms &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="st">&quot;Glory to Hong Kong&quot;</span>, <span class="st">&quot;願榮光歸香港&quot;</span>)</span>
<span class="sourceLine" id="cb2-2" title="2"></span>
<span class="sourceLine" id="cb2-3" title="3"><span class="kw">gtrends</span>(<span class="dt">keyword =</span> search_terms,</span>
<span class="sourceLine" id="cb2-4" title="4">        <span class="dt">geo =</span> <span class="st">&quot;HK&quot;</span>,</span>
<span class="sourceLine" id="cb2-5" title="5">        <span class="dt">time =</span> <span class="st">&quot;today 12-m&quot;</span>) -&gt;<span class="st"> </span>output_results</span></code></pre></div>
<p><code>output_results</code> is a gtrends/list object, which you can extract all kinds of data from:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" title="1">output_results <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">summary</span>()</a></code></pre></div>
<pre><code>##                     Length Class      Mode
## interest_over_time  7      data.frame list
## interest_by_country 0      -none-     NULL
## interest_by_region  0      -none-     NULL
## interest_by_dma     0      -none-     NULL
## interest_by_city    0      -none-     NULL
## related_topics      0      -none-     NULL
## related_queries     6      data.frame list</code></pre>
<p>Let’s have a look at <code>interest_over_time</code>, which is primarily what we’re interested in. You can access the data frame with the <code>$</code> operator, and check out the data structure:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb5-1" title="1">output_results <span class="op">%&gt;%</span><span class="st"> </span></span>
<span class="sourceLine" id="cb5-2" title="2"><span class="st">  </span>.<span class="op">$</span>interest_over_time <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb5-3" title="3"><span class="st">  </span><span class="kw">glimpse</span>()</span></code></pre></div>
<pre><code>## Observations: 104
## Variables: 7
## $ date     &lt;dttm&gt; 2018-10-21, 2018-10-28, 2018-11-04, 2018-11-11, 2018...
## $ hits     &lt;int&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
## $ geo      &lt;chr&gt; &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;, &quot;HK&quot;,...
## $ time     &lt;chr&gt; &quot;today 12-m&quot;, &quot;today 12-m&quot;, &quot;today 12-m&quot;, &quot;today 12-m...
## $ keyword  &lt;chr&gt; &quot;Glory to Hong Kong&quot;, &quot;Glory to Hong Kong&quot;, &quot;Glory to...
## $ gprop    &lt;chr&gt; &quot;web&quot;, &quot;web&quot;, &quot;web&quot;, &quot;web&quot;, &quot;web&quot;, &quot;web&quot;, &quot;web&quot;, &quot;web...
## $ category &lt;int&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...</code></pre>
<p>This is what the <code>hits</code> variable represents, according to <a href="https://support.google.com/trends/answer/4365533?hl=en">Google’s FAQ documentation</a>:</p>
<blockquote>
<p>Google Trends normalizes search data to make comparisons between terms easier. Search results are normalized to the time and location of a query by the following process:</p>
</blockquote>
<blockquote>
<p>Each data point is divided by the total searches of the geography and time range it represents to compare relative popularity. Otherwise, places with the most search volume would always be ranked highest.</p>
</blockquote>
<blockquote>
<p>The resulting numbers are then scaled on a range of 0 to 100 based on a topic’s proportion to all searches on all topics.</p>
</blockquote>
<p>Let us plot this in <strong>ggplot2</strong>, just to try and replicate what we normally see on the Google Trends site - i.e. visualising the search trends over time. I really like the Economist theme from <a href="https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/">ggthemes</a>, so I’ll use that:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb7-1" title="1">output_results <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb7-2" title="2"><span class="st">  </span>.<span class="op">$</span>interest_over_time <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb7-3" title="3"><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> date, <span class="dt">y =</span> hits)) <span class="op">+</span></span>
<span class="sourceLine" id="cb7-4" title="4"><span class="st">  </span><span class="kw">geom_line</span>(<span class="dt">colour =</span> <span class="st">&quot;darkblue&quot;</span>, <span class="dt">size =</span> <span class="fl">1.5</span>) <span class="op">+</span></span>
<span class="sourceLine" id="cb7-5" title="5"><span class="st">  </span><span class="kw">facet_wrap</span>(<span class="op">~</span>keyword) <span class="op">+</span></span>
<span class="sourceLine" id="cb7-6" title="6"><span class="st">  </span>ggthemes<span class="op">::</span><span class="kw">theme_economist</span>() -&gt;<span class="st"> </span>plot</span></code></pre></div>
<p><img src="https://martinctc.github.io/blog/images/gtrendsr-1.png"></p>
<p>This finding above is surprising, because you would expect that Hong Kong people are more likely to search for the Chinese term rather than the English term, as the original piece was written in Cantonese.</p>
<p>I’ll now re-run this piece of analysis, using the shorter term <em>榮光</em>, as the hypothesis is that people are more likely to search for that instead of the full song name. It could also be a quirk of Google Trends that it doesn’t return long Chinese search queries properly.</p>
<p>I’ll try to do this in a single pipe-line. Note what’s done differently this time:</p>
<ul>
<li><code>time</code> is set to 3 months from today</li>
<li>The <code>onlyInterest</code> argument is set to <code>TRUE</code>, which only returns interest over time and therefore is faster.</li>
<li>Google Trends returns hits as <strong>&lt;1</strong> as a character value for a value lower than 1, so let’s replace that with an arbitrary value 0.5 so we can plot this properly (the <code>hits</code> variable needs to be numeric).</li>
</ul>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><span class="sourceLine" id="cb8-1" title="1"><span class="kw">gtrends</span>(<span class="dt">keyword =</span> <span class="kw">c</span>(<span class="st">&quot;Glory to Hong Kong&quot;</span>, <span class="st">&quot;榮光&quot;</span>),</span>
<span class="sourceLine" id="cb8-2" title="2">        <span class="dt">geo =</span> <span class="st">&quot;HK&quot;</span>,</span>
<span class="sourceLine" id="cb8-3" title="3">        <span class="dt">time =</span> <span class="st">&quot;today 3-m&quot;</span>,</span>
<span class="sourceLine" id="cb8-4" title="4">        <span class="dt">onlyInterest =</span> <span class="ot">TRUE</span>) <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb8-5" title="5"><span class="st">  </span>.<span class="op">$</span>interest_over_time <span class="op">%&gt;%</span></span>
<span class="sourceLine" id="cb8-6" title="6"><span class="st">  </span><span class="kw">mutate_at</span>(<span class="st">&quot;hits&quot;</span>, <span class="op">~</span><span class="kw">ifelse</span>(. <span class="op">==</span><span class="st"> &quot;&lt;1&quot;</span>, <span class="fl">0.5</span>, .)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># replace with 0.5</span></span>
<span class="sourceLine" id="cb8-7" title="7"><span class="st">  </span><span class="kw">mutate_at</span>(<span class="st">&quot;hits&quot;</span>, <span class="op">~</span><span class="kw">as.numeric</span>(.)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># convert to numeric</span></span>
<span class="sourceLine" id="cb8-8" title="8"><span class="st">  </span><span class="co"># Begin ggplot</span></span>
<span class="sourceLine" id="cb8-9" title="9"><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> date, <span class="dt">y =</span> hits)) <span class="op">+</span></span>
<span class="sourceLine" id="cb8-10" title="10"><span class="st">  </span><span class="kw">geom_line</span>(<span class="dt">colour =</span> <span class="st">&quot;darkblue&quot;</span>, <span class="dt">size =</span> <span class="fl">1.5</span>) <span class="op">+</span></span>
<span class="sourceLine" id="cb8-11" title="11"><span class="st">  </span><span class="kw">facet_wrap</span>(<span class="op">~</span>keyword) <span class="op">+</span></span>
<span class="sourceLine" id="cb8-12" title="12"><span class="st">  </span>ggthemes<span class="op">::</span><span class="kw">theme_economist</span>() -&gt;<span class="st"> </span>plot2</span></code></pre></div>
<p><img src="https://martinctc.github.io/blog/images/gtrendsr-2.png"></p>
<p>There you go! This is a much more intuitive result, where you’ll find that the search term for “榮光” reaches its peak in mid-September of 2019, whereas search volume for the English term is relatively lower, but still peaks at the same time.</p>
<p>I should caveat that the term “榮光” simply means <em>Glory</em> in Chinese, which people <em>could</em> search for without necessarily searching for the song, but we can be pretty sure that in the context of what’s happening that this search term relates to the actual song itself.</p>
</div>
<div id="limitations" class="section level2">
<h2>Limitations</h2>
<p>One major limitation of Google Trends is that you can only <a href="https://stackoverflow.com/questions/45700811/google-trends-api-more-than-5-search-terms-in-the-csv-file">search a maximum of five terms at the same time</a>, which means that there isn’t really a way to do this at scale. There are some attempts online of doing multiple searches and “connect” the searches together by calculating an index, but so far I’ve not come across any attempts which have yielded a very satisfactory result. However, this is more of a limitation of Google Trends than the package itself.</p>
<p>What you can ultimately do with the <strong>gtrendsR</strong> package is limited by what Google provides, but the benefit of using <strong>gtrendsR</strong> is that all your search inputs will be documented, and certainly helps towards a reproducible workflow.</p>
</div>
<div id="end-notes-side-discussion" class="section level2">
<h2>End notes / side discussion</h2>
<p>This might just be another one of those things you can do in R, but the benefit is relatively minimal given that you cannot scale it very much. This reminds me of a meme:</p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/ian-malcolm.jpeg"></p>
<p>Still, I suppose you can do a lot worse.</p>
<p>Also, writing this particular post made me realise how much more faff is involved when your post features a non-English language and you have to make changes to the encoding - Jekyll (the engine used for generating the static HTML pages on GitHub) isn’t particularly friendly for this purpose. Might be a subject for a separate discussion!</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p><a href="https://en.wikipedia.org/wiki/Glory_to_Hong_Kong" class="uri">https://en.wikipedia.org/wiki/Glory_to_Hong_Kong</a>. For more information about the Hong Kong protests, check out <a href="https://www.helphk.info/" class="uri">https://www.helphk.info/</a>.<a href="#fnref1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p><iframe width="560" height="315" src="https://www.youtube.com/embed/7y5JOd7jWqk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe><a href="#fnref2" class="footnote-back">↩</a></p></li>
</ol>
</div>
</section>
