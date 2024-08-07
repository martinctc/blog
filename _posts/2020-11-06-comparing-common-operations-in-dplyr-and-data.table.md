---
title: "Comparing Common Operations in dplyr and data.table"

author: "Martin Chan"
date: "November 6, 2020"
layout: post
tags: tidyverse rdatatable vignettes r
image: https://raw.githubusercontent.com/martinctc/blog/master/images/manipulate.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-operations-dplyr-datatable-09-11-2020_files/header-attrs-2.3/header-attrs.js"></script>
<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-operations-dplyr-datatable-09-11-2020_files/accessible-code-block-0.0.1/empty-anchor.js"></script>

<section class="main-content">
<div id="background" class="section level1">
<h1>Background</h1>
<p>This post compares common data manipulation operations in <strong>dplyr</strong> and <strong>data.table</strong>.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\manipulate.gif" width="80%" /></p>
<p>For new-comers to R who are not aware, <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/">there are <em>many</em> ways to do the same thing in R</a>. Depending on the purpose of the code (readability vs creating functions) and the size of the data, I for one often find myself switching from one flavour (or dialect) of R data manipulation to another. Generally, I prefer the <strong>dplyr</strong> style for its readability and intuitiveness (for myself), <strong>data.table</strong> for its speed in grouping and summarising operations,<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> and <strong>base R</strong> when I am writing functions. This is by no means the R community consensus by the way (perfectly aware that I am venturing into a total minefield),<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> but is more of a representation of how I personally navigate the messy (but awesome) R world.</p>
<p>In this post, I am going to list out some of the most common data manipulations in both styles:</p>
<ol style="list-style-type: decimal">
<li><code>group_by()</code>, <code>summarise()</code> (a single column)</li>
<li><code>group_by()</code>, <code>summarise_at()</code> (multiple columns)</li>
<li><code>filter()</code>, <code>mutate()</code></li>
<li><code>mutate_at()</code> (changing multiple columns)</li>
<li>Row-wise operations</li>
<li>Vectorised multiple if-else (<code>case_when()</code>)</li>
<li>Function-writing: referencing a column with string</li>
</ol>
<p>There is a vast amount of resources out there on the internet on the comparison of <strong>dplyr</strong> and <strong>data.table</strong>. For those who love to get into the details, I would really recommend <a href="https://atrebas.github.io/post/2019-03-03-datatable-dplyr/">Atrebas’s seminal blog post</a> that gives a comprehensive tour of <strong>dplyr</strong> and <strong>data.table</strong>, comparing the code side-by-side. I would also recommend <a href="https://wetlandscapes.com/blog/a-comparison-of-r-dialects/">this comparison of the three R dialects</a> by Jason Mercer, which not only includes base R in its comparison, but also goes into a fair bit of detail on elements such as piping/chaining (<code>%&gt;%</code>). There’s also a very excellent cheat sheet from DataCamp, linked <a href="https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf">here</a>.</p>
<p>Why write a new blog post then, you ask? One key (selfish / self-centred) reason is that I myself often refer to my blog for an <em>aide-memoire</em> on how to do a certain thing in R, and my notes are optimised to only contain my most frequently used code. They also contain certain idiosyncracies in the way that I code (e.g. using pipes with <strong>data.table</strong>), which I’d like to be upfront about - and would at the same time very much welcome any discussion on it. It is perhaps also justifiable that I at least attempted to build on and unify the work of others in this post, which I have argued as what is ultimately important <a href="https://martinctc.github.io/blog/a-short-essay-on-duplicated-r-artefacts/">in relation of duplicated R artefacts</a>.</p>
<p>Rambling on… so here we go!</p>
<p>To make it easy to reproduce results, I am going to just stick to the good ol’ <strong>mtcars</strong> and <strong>iris</strong> datasets which come shipped with R. I will also err on the side of verbosity and load the packages at the beginning of each code chunk, as if each code chunk is its own independent R session.</p>
</div>
<div id="group_by-summarise-a-single-column" class="section level1">
<h1>1. <code>group_by()</code>, <code>summarise()</code> (a single column)</h1>
<ul>
<li><strong>Analysis</strong>: Maximum MPG (<code>mpg</code>) value for each cylinder type in the <strong>mtcars</strong> dataset.<br />
</li>
<li><strong>Operations</strong>: Summarise with the <code>max()</code> function by group.</li>
</ul>
<p>To group by and summarise values, you would run something like this in <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb1-2"><a href="#cb1-2"></a></span>
<span id="cb1-3"><a href="#cb1-3"></a>mtcars <span class="op">%&gt;%</span></span>
<span id="cb1-4"><a href="#cb1-4"></a><span class="st">    </span><span class="kw">group_by</span>(cyl) <span class="op">%&gt;%</span></span>
<span id="cb1-5"><a href="#cb1-5"></a><span class="st">    </span><span class="kw">summarise</span>(<span class="dt">max_mpg =</span> <span class="kw">max</span>(mpg), <span class="dt">.groups =</span> <span class="st">&quot;drop_last&quot;</span>)</span></code></pre></div>
<p>You could do the same in <strong>data.table</strong>, and still use magrittr pipes:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb2-2"><a href="#cb2-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb2-3"><a href="#cb2-3"></a></span>
<span id="cb2-4"><a href="#cb2-4"></a>mtcars <span class="op">%&gt;%</span></span>
<span id="cb2-5"><a href="#cb2-5"></a><span class="st">    </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb2-6"><a href="#cb2-6"></a><span class="st">    </span>.[,.(<span class="dt">max_mpg =</span> <span class="kw">max</span>(mpg)), by =<span class="st"> </span>cyl]</span></code></pre></div>
</div>
<div id="group_by-summarise_at-multiple-columns" class="section level1">
<h1>2. <code>group_by()</code>, <code>summarise_at()</code> (multiple columns)</h1>
<ul>
<li><strong>Analysis</strong>: Average mean value for <code>Sepal.Width</code> and <code>Sepal.Length</code> for each iris <code>Species</code> in the <strong>iris</strong> dataset.<br />
</li>
<li><strong>Operations</strong>: Summarise with the <code>mean()</code> function by group.</li>
</ul>
<p>Note: this is slightly different from the scenario above because the “summarisation” is applied to multiple columns.</p>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb3-2"><a href="#cb3-2"></a></span>
<span id="cb3-3"><a href="#cb3-3"></a><span class="co"># Option 1</span></span>
<span id="cb3-4"><a href="#cb3-4"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb3-5"><a href="#cb3-5"></a><span class="st">    </span><span class="kw">group_by</span>(Species) <span class="op">%&gt;%</span></span>
<span id="cb3-6"><a href="#cb3-6"></a><span class="st">    </span><span class="kw">summarise_at</span>(<span class="kw">vars</span>(<span class="kw">contains</span>(<span class="st">&quot;Sepal&quot;</span>)),<span class="op">~</span><span class="kw">mean</span>(.))</span>
<span id="cb3-7"><a href="#cb3-7"></a></span>
<span id="cb3-8"><a href="#cb3-8"></a><span class="co"># Option 2</span></span>
<span id="cb3-9"><a href="#cb3-9"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb3-10"><a href="#cb3-10"></a><span class="st">  </span><span class="kw">group_by</span>(Species) <span class="op">%&gt;%</span></span>
<span id="cb3-11"><a href="#cb3-11"></a><span class="st">  </span><span class="kw">summarise</span>(<span class="kw">across</span>(<span class="kw">contains</span>(<span class="st">&quot;Sepal&quot;</span>), mean), <span class="dt">.groups =</span> <span class="st">&quot;drop_last&quot;</span>)</span></code></pre></div>
<p>In <strong>data.table</strong> with pipes:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb4-1"><a href="#cb4-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb4-2"><a href="#cb4-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb4-3"><a href="#cb4-3"></a></span>
<span id="cb4-4"><a href="#cb4-4"></a><span class="co"># Option 1</span></span>
<span id="cb4-5"><a href="#cb4-5"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb4-6"><a href="#cb4-6"></a><span class="st">    </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb4-7"><a href="#cb4-7"></a><span class="st">    </span>.[,<span class="kw">lapply</span>(.SD, mean), by =<span class="st"> </span>Species, .SDcols =<span class="st"> </span><span class="kw">c</span>(<span class="st">&quot;Sepal.Length&quot;</span>, <span class="st">&quot;Sepal.Width&quot;</span>)]</span>
<span id="cb4-8"><a href="#cb4-8"></a>    </span>
<span id="cb4-9"><a href="#cb4-9"></a><span class="co"># Option 2</span></span>
<span id="cb4-10"><a href="#cb4-10"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb4-11"><a href="#cb4-11"></a><span class="st">  </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb4-12"><a href="#cb4-12"></a><span class="st">  </span>.[,<span class="kw">lapply</span>(.SD, mean), by =<span class="st"> </span>Species, .SDcols =<span class="st"> </span><span class="kw">names</span>(.) <span class="op">%like%</span><span class="st"> &quot;Sepal&quot;</span>]</span></code></pre></div>
</div>
<div id="filter-mutate" class="section level1">
<h1>3. <code>filter()</code>, <code>mutate()</code></h1>
<ul>
<li><strong>Analysis</strong>: Find out what the multiple of <code>Sepal.Width</code> and <code>Sepal.Length</code> would be for the iris species <code>setosa</code>.<br />
</li>
<li><strong>Operations</strong>: Filter by <code>Species=="setosa"</code> and create a new column called <code>Sepal_Index</code>.</li>
</ul>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb5-2"><a href="#cb5-2"></a></span>
<span id="cb5-3"><a href="#cb5-3"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb5-4"><a href="#cb5-4"></a><span class="st">    </span><span class="kw">filter</span>(Species <span class="op">==</span><span class="st"> &quot;setosa&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-5"><a href="#cb5-5"></a><span class="st">    </span><span class="kw">mutate</span>(<span class="dt">Sepal_Index =</span> Sepal.Width <span class="op">*</span><span class="st"> </span>Sepal.Length)</span></code></pre></div>
<p>In <strong>data.table</strong>:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb6-1"><a href="#cb6-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb6-2"><a href="#cb6-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb6-3"><a href="#cb6-3"></a></span>
<span id="cb6-4"><a href="#cb6-4"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb6-5"><a href="#cb6-5"></a><span class="st">    </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb6-6"><a href="#cb6-6"></a><span class="st">    </span>.[, Species <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">as.character</span>(Species)] <span class="op">%&gt;%</span></span>
<span id="cb6-7"><a href="#cb6-7"></a><span class="st">    </span>.[Species <span class="op">==</span><span class="st"> &quot;setosa&quot;</span>] <span class="op">%&gt;%</span></span>
<span id="cb6-8"><a href="#cb6-8"></a><span class="st">    </span>.[, Sepal_Index <span class="op">:</span><span class="er">=</span><span class="st"> </span>Sepal.Width <span class="op">*</span><span class="st"> </span>Sepal.Length] <span class="op">%&gt;%</span></span>
<span id="cb6-9"><a href="#cb6-9"></a><span class="st">  </span>.[]</span></code></pre></div>
</div>
<div id="mutate_at-changing-multiple-columns" class="section level1">
<h1>4. <code>mutate_at()</code> (changing multiple columns)</h1>
<ul>
<li><strong>Analysis</strong>: Multiply <code>Sepal.Width</code> and <code>Sepal.Length</code> by 100.<br />
</li>
<li><strong>Operations</strong>: As above</li>
</ul>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb7-2"><a href="#cb7-2"></a></span>
<span id="cb7-3"><a href="#cb7-3"></a><span class="co"># Option 1</span></span>
<span id="cb7-4"><a href="#cb7-4"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb7-5"><a href="#cb7-5"></a><span class="st">    </span><span class="kw">mutate_at</span>(<span class="kw">vars</span>(Sepal.Length, Sepal.Width), <span class="op">~</span>.<span class="op">*</span><span class="dv">100</span>)</span>
<span id="cb7-6"><a href="#cb7-6"></a></span>
<span id="cb7-7"><a href="#cb7-7"></a><span class="co"># Option 2</span></span>
<span id="cb7-8"><a href="#cb7-8"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb7-9"><a href="#cb7-9"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="kw">across</span>(<span class="kw">starts_with</span>(<span class="st">&quot;Sepal&quot;</span>), <span class="op">~</span>.<span class="op">*</span><span class="dv">100</span>))</span></code></pre></div>
<p>In <strong>data.table</strong> with pipes:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb8-1"><a href="#cb8-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb8-2"><a href="#cb8-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb8-3"><a href="#cb8-3"></a></span>
<span id="cb8-4"><a href="#cb8-4"></a></span>
<span id="cb8-5"><a href="#cb8-5"></a>sepal_vars &lt;-<span class="st"> </span><span class="kw">c</span>(<span class="st">&quot;Sepal.Length&quot;</span>, <span class="st">&quot;Sepal.Width&quot;</span>)</span>
<span id="cb8-6"><a href="#cb8-6"></a></span>
<span id="cb8-7"><a href="#cb8-7"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb8-8"><a href="#cb8-8"></a><span class="st">  </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb8-9"><a href="#cb8-9"></a><span class="st">  </span>.[,<span class="kw">as.vector</span>(sepal_vars) <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">lapply</span>(.SD, <span class="cf">function</span>(x) x <span class="op">*</span><span class="st"> </span><span class="dv">100</span>), .SDcols =<span class="st"> </span>sepal_vars] <span class="op">%&gt;%</span></span>
<span id="cb8-10"><a href="#cb8-10"></a><span class="st">  </span>.[]</span></code></pre></div>
</div>
<div id="row-wise-operations" class="section level1">
<h1>5. Row-wise operations</h1>
<p>This is always an awkward one, even for <strong>dplyr</strong>. For this, I will list a couple of options for row-wise calculations.</p>
<ul>
<li><strong>Analysis</strong>: Create a <code>TotalSize</code> column by summing all four columns of <code>Sepal.Length</code>, <code>Sepal.Width</code>, <code>Petal.Length</code>, and <code>Petal.Width</code>.</li>
<li><strong>Operations</strong>: As above</li>
</ul>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb9-2"><a href="#cb9-2"></a></span>
<span id="cb9-3"><a href="#cb9-3"></a><span class="co"># Option 1 - use `rowwise()`</span></span>
<span id="cb9-4"><a href="#cb9-4"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb9-5"><a href="#cb9-5"></a><span class="st">  </span><span class="kw">rowwise</span>() <span class="op">%&gt;%</span></span>
<span id="cb9-6"><a href="#cb9-6"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">TotalSize =</span> <span class="kw">sum</span>(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width))</span>
<span id="cb9-7"><a href="#cb9-7"></a></span>
<span id="cb9-8"><a href="#cb9-8"></a><span class="co"># Option 2 - use `apply()` and `select()`</span></span>
<span id="cb9-9"><a href="#cb9-9"></a><span class="co"># Select all columns BUT `Species`</span></span>
<span id="cb9-10"><a href="#cb9-10"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb9-11"><a href="#cb9-11"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">TotalSize =</span> <span class="kw">select</span>(., <span class="op">-</span>Species) <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">apply</span>(<span class="dt">MARGIN =</span> <span class="dv">1</span>, <span class="dt">FUN =</span> sum))</span>
<span id="cb9-12"><a href="#cb9-12"></a></span>
<span id="cb9-13"><a href="#cb9-13"></a><span class="co"># Option 3 - `rowwise()` and `c_across()`</span></span>
<span id="cb9-14"><a href="#cb9-14"></a><span class="co"># Select all columns BUT `Species`</span></span>
<span id="cb9-15"><a href="#cb9-15"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb9-16"><a href="#cb9-16"></a><span class="st">  </span><span class="kw">rowwise</span>() <span class="op">%&gt;%</span></span>
<span id="cb9-17"><a href="#cb9-17"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">TotalSize =</span> <span class="kw">sum</span>(<span class="kw">c_across</span>(<span class="op">-</span>Species)))</span></code></pre></div>
<p>In <strong>data.table</strong> with pipes:</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb10-1"><a href="#cb10-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb10-2"><a href="#cb10-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb10-3"><a href="#cb10-3"></a></span>
<span id="cb10-4"><a href="#cb10-4"></a><span class="co"># Get all the column names in Species except for `Species`</span></span>
<span id="cb10-5"><a href="#cb10-5"></a>all_vars &lt;-<span class="st"> </span><span class="kw">names</span>(iris)[<span class="kw">names</span>(iris) <span class="op">!=</span><span class="st"> &quot;Species&quot;</span>]</span>
<span id="cb10-6"><a href="#cb10-6"></a></span>
<span id="cb10-7"><a href="#cb10-7"></a>iris <span class="op">%&gt;%</span></span>
<span id="cb10-8"><a href="#cb10-8"></a><span class="st">  </span><span class="kw">as.data.table</span>() <span class="op">%&gt;%</span></span>
<span id="cb10-9"><a href="#cb10-9"></a><span class="st">  </span>.[, <span class="st">&quot;Sepal_Total&quot;</span> <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">apply</span>(.SD, <span class="dv">1</span>, sum), .SDcols =<span class="st"> </span>all_vars] <span class="op">%&gt;%</span></span>
<span id="cb10-10"><a href="#cb10-10"></a><span class="st">  </span>.[]              </span></code></pre></div>
</div>
<div id="vectorised-multiple-if-else-case_when" class="section level1">
<h1>6. Vectorised multiple if-else (<code>case_when()</code>)</h1>
<ul>
<li><strong>Analysis</strong>: Classify an <code>Age</code> into different categories</li>
<li><strong>Operations</strong>: Create a new column called <code>AgeLabel</code> based on the <code>Age</code> variable</li>
</ul>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb11-1"><a href="#cb11-1"></a><span class="kw">library</span>(dplyr)</span>
<span id="cb11-2"><a href="#cb11-2"></a></span>
<span id="cb11-3"><a href="#cb11-3"></a>age_data &lt;-<span class="st"> </span><span class="kw">tibble</span>(<span class="dt">Age =</span> <span class="kw">seq</span>(<span class="dv">1</span>, <span class="dv">100</span>))</span>
<span id="cb11-4"><a href="#cb11-4"></a></span>
<span id="cb11-5"><a href="#cb11-5"></a>age_data <span class="op">%&gt;%</span></span>
<span id="cb11-6"><a href="#cb11-6"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">AgeLabel =</span> <span class="kw">case_when</span>(Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">18</span> <span class="op">~</span><span class="st"> &quot;0 - 17&quot;</span>,</span>
<span id="cb11-7"><a href="#cb11-7"></a>                              Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">35</span> <span class="op">~</span><span class="st"> &quot;18 - 34&quot;</span>,</span>
<span id="cb11-8"><a href="#cb11-8"></a>                              Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">65</span> <span class="op">~</span><span class="st"> &quot;35 - 64&quot;</span>,</span>
<span id="cb11-9"><a href="#cb11-9"></a>                              <span class="ot">TRUE</span> <span class="op">~</span><span class="st"> &quot;65+&quot;</span>))</span></code></pre></div>
<p>In <strong>data.table</strong>:</p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb12-1"><a href="#cb12-1"></a><span class="kw">library</span>(data.table)</span>
<span id="cb12-2"><a href="#cb12-2"></a><span class="kw">library</span>(magrittr) <span class="co"># Or any package that imports the pipe (`%&gt;%`)</span></span>
<span id="cb12-3"><a href="#cb12-3"></a></span>
<span id="cb12-4"><a href="#cb12-4"></a><span class="co"># Option 1 - without pipes</span></span>
<span id="cb12-5"><a href="#cb12-5"></a>age_data &lt;-<span class="st"> </span><span class="kw">data.table</span>(<span class="dt">Age =</span> <span class="dv">0</span><span class="op">:</span><span class="dv">100</span>)</span>
<span id="cb12-6"><a href="#cb12-6"></a>age_data[, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;65+&quot;</span>]</span>
<span id="cb12-7"><a href="#cb12-7"></a>age_data[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">65</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;35-64&quot;</span>]</span>
<span id="cb12-8"><a href="#cb12-8"></a>age_data[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">35</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;18-34&quot;</span>]</span>
<span id="cb12-9"><a href="#cb12-9"></a>age_data[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">18</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;0-17&quot;</span>]        </span>
<span id="cb12-10"><a href="#cb12-10"></a></span>
<span id="cb12-11"><a href="#cb12-11"></a><span class="co"># Option 2 - with pipes</span></span>
<span id="cb12-12"><a href="#cb12-12"></a>age_data2 &lt;-<span class="st"> </span><span class="kw">data.table</span>(<span class="dt">Age =</span> <span class="dv">0</span><span class="op">:</span><span class="dv">100</span>)</span>
<span id="cb12-13"><a href="#cb12-13"></a></span>
<span id="cb12-14"><a href="#cb12-14"></a>age_data2 <span class="op">%&gt;%</span></span>
<span id="cb12-15"><a href="#cb12-15"></a><span class="st">  </span>.[, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;65+&quot;</span>] <span class="op">%&gt;%</span></span>
<span id="cb12-16"><a href="#cb12-16"></a><span class="st">  </span>.[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">65</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;35-64&quot;</span>] <span class="op">%&gt;%</span></span>
<span id="cb12-17"><a href="#cb12-17"></a><span class="st">  </span>.[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">35</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;18-34&quot;</span>] <span class="op">%&gt;%</span></span>
<span id="cb12-18"><a href="#cb12-18"></a><span class="st">  </span>.[Age <span class="op">&lt;</span><span class="st"> </span><span class="dv">18</span>, AgeLabel <span class="op">:</span><span class="er">=</span><span class="st"> &quot;0-17&quot;</span>] <span class="op">%&gt;%</span></span>
<span id="cb12-19"><a href="#cb12-19"></a><span class="st">  </span>.[]</span></code></pre></div>
<p>One thing to note is that there are two options here - Option 2 <em>with</em> and Option 1 <em>without</em> using magrittr pipes. The reason why Option 1 is possible without any assignment (<code>&lt;-</code>) is because of <strong>reference semantics</strong> in <strong>data.table</strong>. When <code>:=</code> is used in <strong>data.table</strong>, a change is made to the data.table object via ‘modify by reference’, without creating a copy of the data.table object; when you assign it to a new object, that is referred to as ‘modify by copy’.</p>
<p>As <a href="https://tysonbarrett.com/jekyll/update/2019/07/12/datatable/">Tyson Barrett</a> nicely summarises, this ‘modifying by reference’ behaviour in <strong>data.table</strong> is partly what makes it efficient, but can be surprising if you do not expect or understand it; however, the good news is that <strong>data.table</strong> gives you the option whether to modify by reference or by making a copy.</p>
</div>
<div id="function-writing-referencing-a-column-with-string" class="section level1">
<h1>7. Function-writing: referencing a column with string</h1>
<ul>
<li><strong>Requirement</strong>: Create a function that will multiply a column by three. A string should be supplied to the argument to specify the column to be multiplied. The function returns the original data frame with the modified column.</li>
</ul>
<p>Here, I intentionally name the packages explicitly within the function and not load them, as it’s best practice for functions to be able to run on their own without loading in an entire library.</p>
<p>In <strong>dplyr</strong>:</p>
<div class="sourceCode" id="cb13"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb13-1"><a href="#cb13-1"></a>multiply_three &lt;-<span class="st"> </span><span class="cf">function</span>(data, variable){</span>
<span id="cb13-2"><a href="#cb13-2"></a>  </span>
<span id="cb13-3"><a href="#cb13-3"></a>  dplyr<span class="op">::</span><span class="kw">mutate</span>(data, <span class="op">!!</span>rlang<span class="op">::</span><span class="kw">sym</span>(variable) <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="op">!!</span>rlang<span class="op">::</span><span class="kw">sym</span>(variable) <span class="op">*</span><span class="st"> </span><span class="dv">3</span>)</span>
<span id="cb13-4"><a href="#cb13-4"></a>}</span>
<span id="cb13-5"><a href="#cb13-5"></a></span>
<span id="cb13-6"><a href="#cb13-6"></a><span class="kw">multiply_three</span>(iris, <span class="st">&quot;Sepal.Length&quot;</span>)</span></code></pre></div>
<p>In <strong>data.table</strong>:</p>
<p>(See <a href="https://stackoverflow.com/questions/45982595/r-using-get-and-data-table-within-a-user-defined-function" class="uri">https://stackoverflow.com/questions/45982595/r-using-get-and-data-table-within-a-user-defined-function</a>)</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb14-1"><a href="#cb14-1"></a>multiply_three &lt;-<span class="st"> </span><span class="cf">function</span>(data, variable){</span>
<span id="cb14-2"><a href="#cb14-2"></a>  </span>
<span id="cb14-3"><a href="#cb14-3"></a>  dt &lt;-<span class="st"> </span>data.table<span class="op">::</span><span class="kw">as.data.table</span>(data)</span>
<span id="cb14-4"><a href="#cb14-4"></a>  dt[, <span class="kw">as.character</span>(<span class="kw">substitute</span>(variable)) <span class="op">:</span><span class="er">=</span><span class="st"> </span><span class="kw">get</span>(variable) <span class="op">*</span><span class="st"> </span><span class="dv">3</span>]</span>
<span id="cb14-5"><a href="#cb14-5"></a>  dt[] <span class="co"># Print</span></span>
<span id="cb14-6"><a href="#cb14-6"></a>}</span>
<span id="cb14-7"><a href="#cb14-7"></a></span>
<span id="cb14-8"><a href="#cb14-8"></a><span class="kw">multiply_three</span>(iris, <span class="st">&quot;Sepal.Length&quot;</span>)</span></code></pre></div>
</div>
<div id="end-note" class="section level1">
<h1>End Note</h1>
<p>This is it! For anything with greater detail, please consult the blogs and cheat sheets I recommended at the beginning of this blog post. I’d say this covers 65% (not a strictly empirical statistic) of my needs for data manipulation, so I hope this is of some help to you. (The <code>gather()</code> vs <code>melt()</code> vs <code>pivot_longer()</code> subject is a whole other beast, and ought to be dealt with in another post)</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>Elio Campitelli has an [excellent blog post] on <em>Why I love data.table</em>, which is a nice short piece on why <strong>data.table</strong> is pretty awesome.<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
<li id="fn2"><p>As noted in the <a href="https://ds4ps.org/2019/04/20/datatable-vs-dplyr.html">DS4PS blog</a>, the debate of <strong>dplyr</strong> versus <strong>data.table</strong> has resulted in “Twitter clashes, and even became an inspiration for memes.”<a href="#fnref2" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
