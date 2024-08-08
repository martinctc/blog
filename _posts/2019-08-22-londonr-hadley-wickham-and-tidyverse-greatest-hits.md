---
title: "LondonR: Hadley Wickham & tidyverse's greatest hits"

author: "Martin Chan"
date: "August 22, 2019"
layout: post
tags: tidyverse r
image: https://martinctc.github.io/blog/images/IMG_8041.jpg
---


<section class="main-content">
<div id="meeting-hadley" class="section level2">
<h2>Meeting Hadley!</h2>
<p><img src="https://martinctc.github.io/blog/images/IMG_8041.jpg" width="100%" style="float:right; padding:10px" /></p>
<p>Last Monday, I had the pleasure of attending a talk given by <a href="http://hadley.nz/">Hadley Wickham</a> at <a href="https://www.londonr.org/">LondonR</a>, which was held at one of their usual venues at the UCL Darwin Lecture Theatre.</p>
<p>For most readers of this blog, Hadley needs no introduction: it is a running joke amongst R users that if <strong>tidyverse</strong> hadn’t been rebranded, it would’ve been known as the <em>hadleyverse</em> - and this pretty much says it all. If it weren’t for his contributions to all these packages (<strong>tidyr</strong>, <strong>dplyr</strong>, and <strong>gplot2</strong> - to name a few), I probably wouldn’t even be using R today.</p>
<p>I had really looked forward to this event, as it’s always an interesting experience to meet in real life these people you seem to know so well or have heard so much about <em>virtually</em>. Another occasion I could recall was Hilary Parker’s keynote address at EARL, which I know her through her brilliant data science podcast (co-hosted with Roger Peng), <a href="http://nssdeviations.com/">Not So Standard Deviations</a>. Do check it out - I highly recommend it.</p>
<p>In this post, I’m going to briefly <code>summarize()</code> (sorry 😆) what Hadley covered in his talk, and some of my thoughts on his points.</p>
</div>
<div id="tidyverse-the-greatest-hits" class="section level2">
<h2>Tidyverse: the greatest hits</h2>
<p><img src="https://martinctc.github.io/blog/images/IMG_8039.jpg" width="100%" style="float:left; padding:10px" /></p>
<p>This was perhaps the busiest LondonR sessions I’ve ever been to, but understandably so! The lecture hall usually has a fair number of free seats left, but on this occasion late-comers struggled to find free seats. Speaking to a couple of other attendees around me, nobody seemed to know in advance what Hadley’s talk was going to be about - this was kept somewhat mysterious when the event opened for registration. Matt Aldridge (CEO of Mango Solutions) introduced the event, and apparently this is a brand new talk by Hadley: <em>Tidyverse: the greatest hits</em>.</p>
<p><img src="https://martinctc.github.io/blog/images/hex-tidyverse.png" width="30%" style="float:right; padding:10px" /></p>
<p>Interestingly, this turned out to be one of those attention-catching titles - what Hadley really planned to talk about was the greatest <em>mistakes</em> of the tidyverse. As he claims, whilst the intuitive expectation of good developers and R coders may be that they make fewer mistakes, it’s more the case for him that he makes <em>many</em> mistakes <em>as fast as possible</em> - which, I imagine, is partly responsible for his prolific body of work in R. Unfortunately, some of these “mistakes” have become “permanent” within tidyverse, which in his talk he explained some of these oddities in the <strong>tidyverse</strong> that most users probably have questioned about at some point.</p>
<p>Hadley mentioned a number of these “permanent mistakes”, and probably two of those which <strong>tidyverse</strong> users resonated the most with are:</p>
<ol style="list-style-type: decimal">
<li>the conflicting function names with <code>stats::filter()</code> and <code>stats::lag()</code></li>
<li>the use of the <code>+</code> operator rather than <code>%&gt;%</code> in <strong>ggplot2</strong></li>
</ol>
<p><img src="https://martinctc.github.io/blog/images/masking-filter-lag.PNG" width="100%" style="float:left; padding:10px" /></p>
<p>Most regular <strong>tidyverse</strong> users would probably have wondered on at least one occasion about the first case: why are there always function conflicts when we run <code>library(tidyverse)</code>, and how do we get rid of it? The function conflict happens because <code>dplyr::filter()</code> and the base <code>stats::filter()</code> have the same name, so it will always conflict if you load <strong>tidyverse</strong>. It is the classic programming problem of naming variables and functions: you may think a variable name is intuitive or sensible initially, but not thinking it through thoroughly enough can sometimes come back and bite you in the future.</p>
<p>Hadley’s argument for choosing <code>filter()</code> as the dplyr verb for filtering rows despite the existence of <code>stats::filter()</code> is because of the relatively niche applications of the latter function.</p>
<p>This is what the documentation of <code>stats::filter()</code> says about the function:</p>
<blockquote>
<p>Applies linear filtering to a univariate time series or to each series separately of a multivariate time series.</p>
</blockquote>
<p>I’ve never used <code>stats::filter()</code> myself and personally find <code>filter()</code> to be quite an intuitive verb, so I’m not too much bothered by this one.</p>
<p>Another similar function-naming “mistake” that Hadley talked about is the lack of intuitiveness of <code>gather()</code> and <code>spread()</code>, where the criticism is that it isn’t immediately clear to an unfamiliar <strong>tidyr</strong> user which of those functions converts data from long to wide format, and vice versa. Unlike <code>dplyr::filter()</code> where there are no plans for a new filtering or subsetting function, in the development version of <strong>tidyr</strong> <a href="https://www.r-bloggers.com/pivoting-data-frames-just-got-easier-thanks-to-pivot_wide-and-pivot_long/">there will be two new functions for pivoting data frames</a>, <code>pivot_wide()</code> and <code>pivot_long()</code>, which remove the ambiguity you get in <code>spread()</code> and <code>gather()</code>. Note that there isn’t any intent to deprecate <code>spread()</code> and <code>gather()</code>, but I think you simply get two new alternatives which make the code easier to read and use.</p>
<p>The other interesting mistake that Hadley talked about is the <code>+</code> operator in <strong>ggplot2</strong>. To put it simply, this refers to the problem that whilst the rest of the <strong>tidyverse</strong> uses the pipe operator <code>%&gt;%</code> to chain analysis steps together, <strong>ggplot2</strong> alone uses a different operator. Here’s a simple illustration of the problem:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r">iris <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># You can pipe</span>
<span class="st">  </span><span class="kw">select</span>(Species, Sepal.Length, Sepal.Width) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Still piping </span>  
  <span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> Sepal.Length, <span class="dt">y =</span> Sepal.Width, <span class="dt">colour =</span> Species)) <span class="op">+</span><span class="st"> </span><span class="co"># You cannot use pipe here</span>
<span class="st">  </span><span class="kw">geom_point</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/londonr-meeting-hadley_22-08-19_files/figure-html/unnamed-chunk-2-1.png" /><!-- --></p>
<p>If you use the <code>%&gt;%</code> operator instead of <code>+</code> once you start to use the ggplot functions, you get the following error message:</p>
<blockquote>
<p>Error: <code>mapping</code> must be created by <code>aes()</code> Did you use %&gt;% instead of +?</p>
</blockquote>
<p>This is very much a mistake of <em>legacy</em>, because the magrittr pipe <code>%&gt;%</code> was not in use when <strong>ggplot2</strong> was written. Again, this feels like a quirk or inconvenience that <strong>tidyverse</strong> users will need to live with, but from a macro perspective <strong>ggplot2</strong> is still a fantastic package with powerful functionalities that played a significant role in popularising the use of R.</p>
<p>Hannah Frick lists a couple more points that Hadley mentioned during his talk:</p>
<blockquote class="twitter-tweet">
<p lang="en" dir="ltr">
The greatest tidyverse mistakes:<br>💥 no pipe in ggplot2<br>💥 overwriting filter and lag<br>💥 using the . in arg names<br>💥 tidyeval pushed too early<br>💥 tidyverse as a name made some people think it's meant to be used in isolation - nah, use it with whatever in <a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">#rstats</a> is useful for you!
</p>
— Hannah Frick (<span class="citation">@hfcfrick</span>) <a href="https://twitter.com/hfcfrick/status/1163519190067793928?ref_src=twsrc%5Etfw">August 19, 2019</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<hr />
</div>
<div id="conclusions" class="section level2">
<h2>Conclusions</h2>
<p>Ultimately, what Hadley wanted to get across for talking about the “mistakes of tidyverse” is perhaps this slide: <img src="https://martinctc.github.io/blog/images/IMG_8040.jpg" width="100%" style="float:right; padding:10px" /></p>
<p>Quote on slide:</p>
<blockquote>
<p>“The cost of never making a mistake is very often never making a change. It’s just too incredibly hard to be sure.” - GeePaw Hill</p>
</blockquote>
<p><a href="http://geepawhill.org/try-different-not-harder/">Here’s a link</a> to the GeePaw Hill blog Hadley referred to.</p>
<p>Are these mistakes “necessary evil”? It’s something to debate about, really. My own view is that these slight quirks and inconveniences are a small price to pay, if they are unavoidable in developing these highly effective R packages in such a short space of time. I do have to say, I am also both impressed and humbled to see Hadley being so open (if not apologetic) about these mistakes in the <strong>tidyverse</strong>.</p>
<p>In the Q&amp;As, there were also a couple of questions that you’d almost expect: what is the future of R, given Python? Hadley’s view is that whilst Python is a great programming language, there are certain peculiarities about R - such as non-standard evaluation - which make it highly effective for doing data science. This enables R to achieve a certain level of fluency for doing data science that Python, without non-standard evaluation, is unlikely to do so. He didn’t go into a huge amount of detail on this controversial debate (raising the Python vs R question amongst this audience is probably no less controversial than Brexit amongst the Brits). However, I did find it intriguing that for someone who did so much for the R language, he sees Python and R as <em>complementary</em> rather than <em>competitive</em>.</p>
<p>Hadley also made it very clear that the intent isn’t for <strong>tidyverse</strong> to be used on its own (without other packages), but as a starting point. It doesn’t matter, for instance, if you use <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/"><strong>data.table</strong> and <strong>tidyverse</strong> together</a>.</p>
<p>This was a great LondonR session, even though the content was much more about programming than data science. A big thank you to Hadley Wickham and the Mango Solutions team for organising this!</p>
</div>
</section>
