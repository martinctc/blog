---
title: "First Post"

author: "Martin Chan"
date: "April 13, 2019"
layout: post
---


<section class="main-content">
<p>Ever since I discovered <a href="https://www.r-bloggers.com/">r-bloggers</a> and had subsequently learnt so much from the useful articles contributed by R users all around the world, I’ve wanted to start a R blog myself. Part of the motivation is give back to the open source community, since I myself had benefitted so much from R vignettes, blogs, and Stack Overflow discussions. Another part of the motivation is to train myself to present code and ideas in a clear and understandable format, such that anyone else (or my future self) could understand what happened.</p>
<p>This isn’t actually the first time I’ve tried to blog about R or any content with code, but on previous occasions I’ve felt discouraged or given up, partly because of the faff involved in getting the syntax highlighting and plots to display in the way that I want (I previously tried to blog on blogspot.com). I then heard about all this talk about blogging using RMarkdown - <em>what?</em> I decided to give it a try and was pleasantly surprised by how easy and streamlined the entire process was. I can even show ggplots! (Yes, it’s <em>iris</em> again, groan - but hey, it works!)</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">iris <span class="op">%&gt;%</span>
<span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> Sepal.Length, <span class="dt">y =</span> Sepal.Width, <span class="dt">color =</span> Species)) <span class="op">+</span>
<span class="st">  </span><span class="kw">geom_point</span>()</code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/First_Post_13-04-19_files/figure-html/unnamed-chunk-2-1.png" /><!-- --></p>
<p>If you’re interested in blogging about R, I highly recommend that you give it a go. I even managed to host this on GitHub pages, which means you get free hosting, which is pretty bomb.</p>
<p>To get started, check out <a href="https://github.com/privefl/jekyll-now-r-template">this</a> repo, which provides a template to build a lightweight, effective blog optimised for sharing R code.</p>
<div id="note" class="section level2">
<h2>Note</h2>
<p>This is my first ever time creating a blog post using only RMarkdown. I used a template from the package called <code>prettyjekyll</code>, which was fairly straightforward. A lot of the styling and the inital code was borrowed from Florian Privé, where you can check out his Github account at <a href="https://github.com/privefl" class="uri">https://github.com/privefl</a>.</p>
</div>
</section>
