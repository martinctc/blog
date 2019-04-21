---
title: "Using data.table with magrittr pipes: best of both worlds"

author: "Martin Chan"
date: "April 21, 2019"
layout: post
---


<section class="main-content">
<blockquote>
<p>Should we use magrittr pipes with data.table?</p>
</blockquote>
<div id="why-ask-the-question" class="section level2">
<h2>Why ask the question?</h2>
<p>If you are fairly new to R, you might find it puzzling / intriguing that R questions on Stack Overflow tend to attract a range of solutions which all have different syntax “styles”, but almost all seem to valid answers to some extent (as indicated by the number of upvotes to the solution). This is because there are three main syntax styles in the R universe:</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\Rlogo.png" width="20%" style="float:right; padding:10px" /></p>
<ol style="list-style-type: decimal">
<li><strong>base R</strong> - This refers to a syntax style that mostly utilises functions and operators available within “base” packages, notably <strong>base</strong> but also <strong>stats</strong>. These are packages that are loaded automatically when you start up R.<a href="#fn1" class="footnoteRef" id="fnref1"><sup>1</sup></a> In the context of <code>iris</code> dataset, the use of <code>iris$Species</code> or <code>iris[[&quot;Species&quot;]]</code> to refer to columns, or <code>subset(iris, Species == &quot;setosa&quot;)</code> to subset/filter rows are characteristic of the base R style. My intuition says that R code written prior to 2014 (based on books and Stack Overflow solutions) are more likely to be in this style.<a href="#fn2" class="footnoteRef" id="fnref2"><sup>2</sup></a></li>
</ol>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\hex-tidyverse.png" width="20%" style="float:right; padding:10px" /></p>
<ol start="2" style="list-style-type: decimal">
<li><strong>tidyverse / dplyr style</strong> - This is a style that is increasingly becoming the ‘standard’ style for data analysis due to its superb readability and consistency with an ecosystem of packages e.g. “official” tidyverse packages such as <strong>stringr</strong> and <strong>purrr</strong>, but also packages written with the same principles in mind such as <strong>tidytext</strong>, <strong>tidyquant</strong>, and <strong>srvyr</strong>, to name a few. The tidyverse style is based on a set of <a href="https://tidyverse.tidyverse.org/articles/manifesto.html">principles</a> which is designed to enhance analysis through greater readability and reproducibility. The hallmark of this style is the <code>%&gt;%</code> pipe operator (from the <strong>magrittr</strong> package), which chains up analysis operations in a way that enables you to “read” code in the form of “do x, then do y, then do z…”. Other functions that are characteristic of this style include <code>mutate()</code>, <code>filter()</code>, and <code>group_by()</code>.</li>
</ol>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\r-datatable.png" width="20%" style="float:right; padding:10px" /></p>
<ol start="3" style="list-style-type: decimal">
<li><strong>data.table style</strong> - Unlike the tidyverse style, the data.table style is primarily based off a single package: <a href="https://github.com/Rdatatable/data.table/wiki">data.table</a>. The package description for data.table puts it as:</li>
</ol>
<blockquote>
<p><em>“Fast aggregation of large data (e.g. 100GB in RAM), fast ordered joins, fast add/modify/delete of columns by group using no copies at all, list columns, friendly and fast character-separated-value read/write. Offers a natural and ﬂexible syntax, for faster development.”</em></p>
</blockquote>
<p>The key advantage that I value in data.table is its speed, especially when working with grouping operations that involve a large number of groups (e.g. analysis by PEOPLE groups in a VISIT/TRANSACTION level database), where my experience is that it is much faster than dplyr. Syntax-wise, it is fairly readable, perhaps somewhere in between <strong>dplyr</strong> and <strong>base</strong> (there is always an element of subjectivity in this - you read better what you are most familiar with!).</p>
<hr />
<p>Okay, now to the main point of this post.</p>
<p>All these three styles mentioned above have their own pros and cons, but the general convention/advice is that one should stick with a single style in the same piece of analysis, so that other people can more easily what you are doing. Imagine trying to read a piece of analysis where someone filters a row in three different ways (I can think of eight ways without trying too hard, actually)! 🙈</p>
<p>But what if I had a legitimate reason for combining these styles in my code?</p>
</div>
<div id="use-case-combining-magrittr-pipes-and-data.table" class="section level2">
<h2>Use Case: Combining magrittr pipes and data.table</h2>
<p>I’ve once worked on a piece of analysis where I used the “tidyverse” style (i.e. <strong>dplyr</strong> verbs + <strong>magrittr</strong> pipes), chiefly for the reason that it makes my code more readable. This worked fine when I was only dealing with the summarised numbers from the analysis, but when I had to group or join data from the significantly larger raw data it became agonisingly slow - to the extent that you can make cups of tea in between runs.</p>
<p>☕ ☕ ☕</p>
<p>I then decided to switch to data.table for that specific part of the analysis, but felt somewhat uneasy with the fact that I’m now making the code more complex by introducing another “style”. Then I realised that I could minimise the complexity and preserving the readability by using magrittr pipes on data.table.</p>
<p>Below is an example where I would take some data in an ordinary ‘base’ data frame, convert into a data.table object, run some analysis on it, and convert this back into a tibble object.</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(nycflights13)

nycflights13<span class="op">::</span>flights <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># `flights` dataset from nycflights13</span>
<span class="st">  </span>data.table<span class="op">::</span><span class="kw">as.data.table</span>() -&gt;<span class="st"> </span>flights_tb <span class="co"># Convert to data.table</span>

<span class="co"># Run some analysis on delay times</span>
<span class="co"># Create a new column called carrier_flight, then use it as a grouping variable</span>
<span class="co"># Use data.table syntax</span>
flights_tb <span class="op">%&gt;%</span>
<span class="st">  </span>.[, carrier_flight <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">paste0</span>(carrier,<span class="st">&quot;_&quot;</span>,flight)] <span class="op">%&gt;%</span>
<span class="st">  </span>.[,.(<span class="dt">dep_delay =</span> <span class="kw">mean</span>(dep_delay, <span class="dt">na.rm =</span> <span class="ot">TRUE</span>),
       <span class="dt">arr_delay =</span> <span class="kw">mean</span>(arr_delay, <span class="dt">na.rm =</span> <span class="ot">TRUE</span>)), by =<span class="st"> </span>carrier_flight] <span class="op">%&gt;%</span>
<span class="st">  </span>dplyr<span class="op">::</span><span class="kw">as_tibble</span>() <span class="co"># Convert this back to a tibble (tidyverse) object</span></code></pre></div>
<pre><code>## # A tibble: 5,725 x 3
##    carrier_flight dep_delay arr_delay
##    &lt;chr&gt;              &lt;dbl&gt;     &lt;dbl&gt;
##  1 UA_1545            1.51     -9.75 
##  2 UA_1714            5.11     -2.68 
##  3 AA_1141            2.10     -6.56 
##  4 B6_725             0.975     1.66 
##  5 DL_461            -0.709    -5.83 
##  6 UA_1696           21.6       8    
##  7 B6_507             0.789    -0.133
##  8 EV_5708           16.9       8.85 
##  9 B6_79             -0.441    -2.32 
## 10 AA_301            -3.01    -10.9  
## # ... with 5,715 more rows</code></pre>
<p>My justification of such a ‘hybrid’ approach is that marries the readability of <strong>dplyr</strong> / <strong>magrittr</strong> pipes <code>%&gt;%</code> and the blazing speed of <strong>data.table</strong>. To be fair, doing everything in <strong>dplyr</strong> isn’t <em>always</em> slower, although there are clearly scenarios where data.table has a performance advantage. (See either <a href="https://tom.alby.de/en/r-dplyr-sparklyr-vs-data-table-performance/">Tom Alby’s post</a> on dplyr vs sparklyr vs data.table performance and <a href="https://www.gettinggeneticsdone.com/2015/01/microbenchmark-package-r-compare-runtime-r-expressions.html">Stephen Turner’s post</a> comparing various R expressions using <strong>microbenchmark</strong>)</p>
<p>The other alternative is to stick with data.table entirely, but the way that <strong>data.table</strong> is chained “traditionally” does not feel as intuitive to me (hitting ‘return’ between each <code>][</code> chain:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r">flights_tb[,carrier_flight<span class="op">:</span><span class="er">=</span><span class="kw">paste0</span>(carrier,<span class="st">&quot;_&quot;</span>,flight)
           ][,.(<span class="dt">dep_delay =</span> <span class="kw">mean</span>(dep_delay, <span class="dt">na.rm =</span> <span class="ot">TRUE</span>),
                <span class="dt">arr_delay =</span> <span class="kw">mean</span>(arr_delay, <span class="dt">na.rm =</span> <span class="ot">TRUE</span>)), by =<span class="st"> </span>carrier_flight]</code></pre></div>
<p>Given these circumstances, combining <code>%&gt;%</code> and <strong>data.table</strong> was an approach that worked really well for me.</p>
</div>
<div id="more-on-this-debate" class="section level2">
<h2>More on this debate</h2>
<p>I later discovered that quite a few others have also adopted this convention of combining <code>%&gt;%</code> and <strong>data.table</strong>: <a href="https://stackoverflow.com/questions/33761872/break-data-table-chain-into-two-lines-of-code-for-readability/36873717#36873717">this</a> Stack Overflow response, <a href="https://www.gl-li.com/2017/07/25/compare-data.table-pipes-and-magrittr-pipes/">this</a> blog post by G L Li, and also another <a href="http://jeffreyhorner.tumblr.com/post/120109449643/no-this-is-how-you-dplyr-and-datatable">one</a> by Jeffrey Horner. It’s good to know I’m not the only one!</p>
<p>The wider divergence between the three syntax styles within R also is an interesting subject on its own. The question in this blog is mainly about <strong>tidyverse</strong> versus <strong>data.table</strong>, but that doesn’t mean there isn’t a debate around <strong>base R</strong>: Jozef Hajnala has a website called <a href="https://jozefhajnala.gitlab.io/r/categories/rcase4base/">case4base</a>, which as advertised, makes a case for using base R. But how should new users learn R? To what extent should we combine styles? When should we use which style? These are all important questions that the R community needs to think and discuss about.</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>See following link regarding packages that are loaded on start up: <a href="https://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html" class="uri">https://stat.ethz.ch/R-manual/R-patched/library/base/html/Startup.html</a><a href="#fnref1">↩</a></p></li>
<li id="fn2"><p>Not based on actual research, just a hunch - but a 2018 article from <a href="https://www.waldrn.com/dplyr-vs-data-table/">David Waldron</a> seems to support my hunch.<a href="#fnref2">↩</a></p></li>
</ol>
</div>
</section>
