---
title: "First Post"

author: "Martin Chan"
date: "April 13, 2019"
layout: post
tags: learning-r
image: http://martinctc.github.io/blog/images/brace-yourselves.png
---


<section class="main-content">
<div id="why-start-a-r-blog" class="section level2">
<h2>Why start a R blog?</h2>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/brace-yourselves.png" width="40%" style="float:right; padding:10px" /></p>
<p>Ever since I discovered <a href="https://www.r-bloggers.com/">r-bloggers</a> and had subsequently learnt immensely from the articles contributed by R users all around the world, I’ve wanted to start a R blog myself. Part of the motivation is give back to the open source community. Since I myself had benefitted so much from R vignettes, blogs, and Stack Overflow discussions, it feels right that I should give something back in some form to the newcomers to R, now that I am able to code in R reasonably well. Another part of the motivation is that I wanted to train myself to present code and ideas in a clear and understandable format. Not only does this encourage myself to think harder about my analysis, good documentation means that anyone else (or my future self) could understand what happened with the analysis. Moreover, as my friend <a href="https://datastrategywithjonathan.com/">Jonathan Ng</a> loves to say, blogging is <em>scalable</em> - you can get to so many more people through blogging than simply through one-to-one conversations. And after all, sharing is caring!</p>
<p>This isn’t actually the first time I’ve tried to blog about R or any content with code, but on previous occasions I’ve felt discouraged or given up halfway. Partly, this was because of the faff involved in getting the syntax highlighting and plots to display in the way that I want (I previously tried to blog on blogspot.com - not straightforward, in my experience). I then heard about blogging using RMarkdown - <em>what? That’s possible?</em> I decided to give it a try and was pleasantly surprised by how easy and streamlined the entire process was. I can even show ggplots! (Yes, it’s <em>iris</em> again, groan - but hey, it works!)</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">iris <span class="op">%&gt;%</span>
<span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> Sepal.Length, <span class="dt">y =</span> Sepal.Width, <span class="dt">color =</span> Species)) <span class="op">+</span>
<span class="st">  </span><span class="kw">geom_point</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/First_Post_13-04-19_files/figure-html/plot-1.png" /><!-- --></p>
<p>If you’re interested in blogging about R, I highly recommend that you give it a go. I even managed to host this on GitHub pages, which means you get free hosting, which is pretty bomb.</p>
<p>To get started, check out <a href="https://github.com/privefl/jekyll-now-r-template">this</a> repo by Florian Privé, which provides a template to build a lightweight, effective blog optimised for sharing R code.</p>
</div>
<div id="note" class="section level2">
<h2>Note</h2>
<p>This is my first ever time creating a blog post using only RMarkdown. I used a template from the package called <code>prettyjekyll</code>, which was fairly straightforward. A lot of the styling and the inital code was borrowed from Florian Privé, where you can check out his Github account at <a href="https://github.com/privefl" class="uri">https://github.com/privefl</a>.</p>
</div>
</section>
