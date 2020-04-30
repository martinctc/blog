---
title: "Vignette: Simulating a minimal SPSS dataset from R"

author: "Martin Chan"
date: "April 30, 2020"
layout: post
tags: surveys vignettes tidyverse
image: https://raw.githubusercontent.com/martinctc/blog/master/images/surveysays.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/minimal-sav_22-04-2020_files/header-attrs-2.1.1/header-attrs.js"></script>

<section class="main-content">
<div id="tldr" class="section level2">
<h2>What this is about 📖</h2>
<p>I will simulate a minimal <strong>labelled survey</strong> dataset that can be exported as a SPSS (.SAV) file (with full variable and value labels) in R. I will also attempt to fabricate ‘meaningful patterns’ to the dataset such that it can be more effectively used for creating demo examples.</p>
<div class="figure">
<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/surveysays.gif" alt="" />
<p class="caption">image from Giphy</p>
</div>
</div>
<div id="background" class="section level2">
<h2>Background</h2>
<p>Simulating data is one of the most useful skills to have in R. For one, it is helpful when you’re debugging code, and you want to create a <strong>reprex</strong> (reproducible example) to ask for help more effectively (<em>help others help you </em>, as the saying goes.)<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> However, regardless of whether you’re a researcher or a business analyst, the data associated with your code is likely to be either <strong>confidential</strong> so you cannot share it on <a href="https://stackoverflow.com/">Stack Overflow</a>, or way too large or complex for you to upload anyway. Creating an example dataset from a few lines of code which you can safely share is an effective way to get around this problem.</p>
<p>Data simulation is slightly more tricky with <strong>survey datasets</strong>, which are characterised by (1) <strong>labels on both variable and values/codes</strong>, and (2) <strong>a large proportion of ordinal / categorical variables</strong>.</p>
<p>For instance, a Net Promoter Score (NPS) variable is usually accompanied with the variable label <em>“On a scale of 0-10, how likely are you to recommend X to a friend or family?”</em> (i.e. the actual question asked in a survey), and is itself an instance of an ordinal variable. If you are trying to produce an example that hinges on an issue where labels are relevant, you would also need to simulate the labels as well.</p>
<p>There are also <em>educational</em> reasons for simulating data: it is useful to simulate data to demo an analysis or a function, because this makes it easy for the audience to reproduce the example. For this purpose, it would be especially beneficial if you can simulate a dataset where there you can introduce some arbitrary relationships between the variables, rather than them being completely random (<code>sample()</code> all the way).</p> 

<p>Personally, I have in the past found it a pain to simulate datasets which are suited for demo-ing survey related functions, especially when I was working on examples for the <a href="https://www.github.com/martinctc/surveytoolbox">{surveytoolbox}</a> package 📦. Hence, this is partly an attempt to simulate a labelled dataset that is minimally sufficient for demonstrating some of the <a href="https://www.github.com/martinctc/surveytoolbox">{surveytoolbox}</a> functions.</p>
<p>🏷 For more information specifically on manipulating labels in R, do check out a previous post I’ve written on <a href="https://martinctc.github.io/blog/working-with-spss-labels-in-r/">working with SPSS labels in R</a>.</p>
</div>
<div id="getting-started" class="section level2">
<h2>Getting started</h2>
<p>To run this example, we’ll need to load <a href="https://www.tidyverse.org/">{tidyverse}</a>, <a href="https://www.github.com/martinctc/surveytoolbox">{surveytoolbox}</a>, and <a href="https://haven.tidyverse.org/">{haven}</a>. Specifically, I’m using {tidyverse} for its data manipulation functions, {surveytoolbox} for functions to set up variable/value labels, and finally {haven} to export the data as a .SAV file.</p>
<p>Note that {surveytoolbox} is currently not available on CRAN yet, but you can install this by running <code>devtools::install_github("martinctc/surveytoolbox")</code>. You’ll need {devtools} installed, if you haven’t got it already.</p>
<p>In addition to loading the packages, we will also set the seed<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> with <code>set.seed()</code> to make the simulated numbers reproducible:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="kw">library</span>(tidyverse)</span>
<span id="cb1-2"><a href="#cb1-2"></a><span class="kw">library</span>(surveytoolbox) <span class="co"># Install with devtools::install_github(&quot;martinctc/surveytoolbox&quot;)</span></span>
<span id="cb1-3"><a href="#cb1-3"></a><span class="kw">library</span>(haven)</span>
<span id="cb1-4"><a href="#cb1-4"></a></span>
<span id="cb1-5"><a href="#cb1-5"></a><span class="kw">set.seed</span>(<span class="dv">100</span>) <span class="co"># Enable reproducibility - 100 is arbitrary</span></span></code></pre></div>
</div>
<div id="create-individual-vectors" class="section level2">
<h2>Create individual vectors</h2>
<p>For the purpose of clarity and ease of debugging, my approach will be to first set up each simulated variable as individual labelled vectors, and then bind them together into a data frame at the end. To adorn variable and value labels to a numeric vector, I will use <code>set_varl()</code> and <code>set_vall()</code> from {surveytoolbox} to do these tasks respectively.</p>
<p>I want to create a dataset with 1000 observations, so I will start with creating <code>v_id</code> as an ID variable running from 1 to 1000, which can simply be generated with the <code>seq()</code> function.<a href="#fn3" class="footnote-ref" id="fnref3"><sup>3</sup></a> I will then use <code>set_varl()</code> from {surveytoolbox} to set a variable label for the <code>v_id</code> vector. The second argument of <code>set_varl()</code> takes in a character vector and assigns it as the variable label of the target variable - super straightforward.</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1"></a><span class="co">## Record Identifier</span></span>
<span id="cb2-2"><a href="#cb2-2"></a>v_id &lt;-</span>
<span id="cb2-3"><a href="#cb2-3"></a><span class="st">  </span><span class="kw">seq</span>(<span class="dv">1</span>, <span class="dv">1000</span>) <span class="op">%&gt;%</span></span>
<span id="cb2-4"><a href="#cb2-4"></a><span class="st">  </span><span class="kw">set_varl</span>(<span class="st">&quot;Record Identifier&quot;</span>)</span></code></pre></div>
<p>The same goes for <code>v_gender</code>, but this time I want to also (1) <em>apply an arbitrary probability to the distribution</em>, and (2) <em>give each value in the vector a value label (“Male”, “Female”, “Other”)</em>.</p>
<p>To do (1), I pass a numeric vector to the <code>prob</code> argument to represent the probabilities that 1, 2, and 3 will fall out for n = 1000.</p>
<p>To do (2), I run <code>set_vall()</code> and pass the desired labels to the <code>value_labels</code> argument. <code>set_vall()</code> acccepts a named character vector to be assigned as value labels.</p>
<p>Finally, I run <code>set_varl()</code> again to make sure that a variable label is present.</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1"></a><span class="co">## Gender</span></span>
<span id="cb3-2"><a href="#cb3-2"></a>v_gender &lt;-</span>
<span id="cb3-3"><a href="#cb3-3"></a><span class="st">  </span><span class="kw">sample</span>(<span class="dt">x =</span> <span class="dv">1</span><span class="op">:</span><span class="dv">3</span>,</span>
<span id="cb3-4"><a href="#cb3-4"></a>         <span class="dt">size =</span> <span class="dv">1000</span>, <span class="dt">replace =</span> <span class="ot">TRUE</span>,</span>
<span id="cb3-5"><a href="#cb3-5"></a>         <span class="dt">prob =</span> <span class="kw">c</span>(.<span class="dv">48</span>, <span class="fl">.48</span>, <span class="fl">.04</span>)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># arbitrary probability</span></span>
<span id="cb3-6"><a href="#cb3-6"></a><span class="st">  </span><span class="kw">set_vall</span>(<span class="dt">value_labels =</span> <span class="kw">c</span>(<span class="st">&quot;Male&quot;</span> =<span class="st"> </span><span class="dv">1</span>,</span>
<span id="cb3-7"><a href="#cb3-7"></a>                            <span class="st">&quot;Female&quot;</span> =<span class="st"> </span><span class="dv">2</span>,</span>
<span id="cb3-8"><a href="#cb3-8"></a>                            <span class="st">&quot;Other&quot;</span> =<span class="st"> </span><span class="dv">3</span>)) <span class="op">%&gt;%</span></span>
<span id="cb3-9"><a href="#cb3-9"></a><span class="st">  </span><span class="kw">set_varl</span>(<span class="st">&quot;Q1. Gender&quot;</span>)</span></code></pre></div>
<p>Now that we’ve got our ID variable and a basic grouping variable (gender), let’s also create some mock metric variables.</p>
<p>I want to create a 5-point scale KPI variable (which could represent <em>customer satisfaction</em> or <em>likelihood to recommend</em>). One way to do this is to simply run <code>sample()</code> again, and do the same thing we did for <code>v_gender</code>:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb4-1"><a href="#cb4-1"></a><span class="co">## KPI - #1 simple sampling</span></span>
<span id="cb4-2"><a href="#cb4-2"></a>v_kpi &lt;-</span>
<span id="cb4-3"><a href="#cb4-3"></a><span class="st">  </span><span class="kw">sample</span>(<span class="dt">x =</span> <span class="dv">1</span><span class="op">:</span><span class="dv">5</span>,</span>
<span id="cb4-4"><a href="#cb4-4"></a>         <span class="dt">size =</span> <span class="dv">1000</span>,</span>
<span id="cb4-5"><a href="#cb4-5"></a>         <span class="dt">replace =</span> <span class="ot">TRUE</span>) <span class="op">%&gt;%</span></span>
<span id="cb4-6"><a href="#cb4-6"></a><span class="st">  </span><span class="kw">set_vall</span>(<span class="dt">value_labels =</span> <span class="kw">c</span>(<span class="st">&quot;Extremely dissatisfied&quot;</span> =<span class="st"> </span><span class="dv">1</span>,</span>
<span id="cb4-7"><a href="#cb4-7"></a>                            <span class="st">&quot;Somewhat dissatisfied&quot;</span> =<span class="st"> </span><span class="dv">2</span>,</span>
<span id="cb4-8"><a href="#cb4-8"></a>                            <span class="st">&quot;Neither&quot;</span> =<span class="st"> </span><span class="dv">3</span>,</span>
<span id="cb4-9"><a href="#cb4-9"></a>                            <span class="st">&quot;Satisfied&quot;</span> =<span class="st"> </span><span class="dv">4</span>,</span>
<span id="cb4-10"><a href="#cb4-10"></a>                            <span class="st">&quot;Extremely satisfied&quot;</span> =<span class="st"> </span><span class="dv">5</span>)) <span class="op">%&gt;%</span></span>
<span id="cb4-11"><a href="#cb4-11"></a><span class="st">  </span><span class="kw">set_varl</span>(<span class="st">&quot;Q2. KPI&quot;</span>)</span></code></pre></div>
<p>Whilst the above approach is straightforward, the downside is that the numbers are likely to look completely random if we try to actually analyse the results - which is what <code>sample()</code> is supposed to do - but clearly isn’t ideal.</p>
<p>I want to simulate numbers that are more realistic, i.e. data which will form a discernible pattern when grouping and summarising by gender. What I’ll therefore do is to iterate through each number in <code>v_gender</code>, and sample numbers based on the gender of the ‘respondent’.</p>
<p>The values that are passed below to the <code>prob</code> argument within <code>sample()</code> are completely arbitrary, but are designed to generate results where a bigger KPI value is more likely if <code>v_gender == 1</code>, followed by <code>v_gender == 3</code>, then <code>v_gender == 2</code>.</p>
<p>Note that I’ve used <code>map2_dbl()</code> here (from the {purrr} package, part of {tidyverse}), which “loops” through <code>v_gender</code> and returns a numeric value for each iteration.</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1"></a><span class="co">## KPI - #2 gender-dependent sampling</span></span>
<span id="cb5-2"><a href="#cb5-2"></a>v_kpi &lt;-</span>
<span id="cb5-3"><a href="#cb5-3"></a><span class="st">  </span>v_gender <span class="op">%&gt;%</span></span>
<span id="cb5-4"><a href="#cb5-4"></a><span class="st">  </span><span class="kw">map_dbl</span>(<span class="cf">function</span>(x){</span>
<span id="cb5-5"><a href="#cb5-5"></a>    <span class="cf">if</span>(x <span class="op">==</span><span class="st"> </span><span class="dv">1</span>){</span>
<span id="cb5-6"><a href="#cb5-6"></a>      <span class="kw">sample</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">5</span>,</span>
<span id="cb5-7"><a href="#cb5-7"></a>             <span class="dt">size =</span> <span class="dv">1</span>,</span>
<span id="cb5-8"><a href="#cb5-8"></a>             <span class="dt">prob =</span> <span class="kw">c</span>(<span class="dv">10</span>, <span class="dv">17</span>, <span class="dv">17</span>, <span class="dv">28</span>, <span class="dv">28</span>)) <span class="co"># Sum to 100</span></span>
<span id="cb5-9"><a href="#cb5-9"></a>    } <span class="cf">else</span> <span class="cf">if</span>(x <span class="op">==</span><span class="st"> </span><span class="dv">2</span>){</span>
<span id="cb5-10"><a href="#cb5-10"></a>      <span class="kw">sample</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">5</span>,</span>
<span id="cb5-11"><a href="#cb5-11"></a>             <span class="dt">size =</span> <span class="dv">1</span>,</span>
<span id="cb5-12"><a href="#cb5-12"></a>             <span class="dt">prob =</span> <span class="kw">c</span>(<span class="dv">11</span>, <span class="dv">22</span>, <span class="dv">28</span>, <span class="dv">22</span>, <span class="dv">17</span>)) <span class="co"># Sum to 100</span></span>
<span id="cb5-13"><a href="#cb5-13"></a></span>
<span id="cb5-14"><a href="#cb5-14"></a>    } <span class="cf">else</span> {</span>
<span id="cb5-15"><a href="#cb5-15"></a>      <span class="kw">sample</span>(<span class="dv">1</span><span class="op">:</span><span class="dv">5</span>,</span>
<span id="cb5-16"><a href="#cb5-16"></a>             <span class="dt">size =</span> <span class="dv">1</span>,</span>
<span id="cb5-17"><a href="#cb5-17"></a>             <span class="dt">prob =</span> <span class="kw">c</span>(<span class="dv">13</span>, <span class="dv">20</span>, <span class="dv">20</span>, <span class="dv">27</span>, <span class="dv">20</span>)) <span class="co"># Sum to 100</span></span>
<span id="cb5-18"><a href="#cb5-18"></a>    }</span>
<span id="cb5-19"><a href="#cb5-19"></a>  }) <span class="op">%&gt;%</span></span>
<span id="cb5-20"><a href="#cb5-20"></a><span class="st">  </span><span class="kw">set_vall</span>(<span class="dt">value_labels =</span> <span class="kw">c</span>(<span class="st">&quot;Extremely dissatisfied&quot;</span> =<span class="st"> </span><span class="dv">1</span>,</span>
<span id="cb5-21"><a href="#cb5-21"></a>                            <span class="st">&quot;Somewhat dissatisfied&quot;</span> =<span class="st"> </span><span class="dv">2</span>,</span>
<span id="cb5-22"><a href="#cb5-22"></a>                            <span class="st">&quot;Neither&quot;</span> =<span class="st"> </span><span class="dv">3</span>,</span>
<span id="cb5-23"><a href="#cb5-23"></a>                            <span class="st">&quot;Satisfied&quot;</span> =<span class="st"> </span><span class="dv">4</span>,</span>
<span id="cb5-24"><a href="#cb5-24"></a>                            <span class="st">&quot;Extremely satisfied&quot;</span> =<span class="st"> </span><span class="dv">5</span>)) <span class="op">%&gt;%</span></span>
<span id="cb5-25"><a href="#cb5-25"></a><span class="st">  </span><span class="kw">set_varl</span>(<span class="st">&quot;Q2. KPI&quot;</span>)</span></code></pre></div>
<p>To add a level of complexity, let me also simulate a mock NPS variable. One way to do this is to punch in random numbers like how it is done above with <code>v_kpi</code>, but this will involve a lot more random punching than is desirable for a 11-point scale NPS variable.</p>
<p>I will therefore instead write a custom function called <code>skew_inputs()</code> that ‘expands’ three arbitrary input numbers into 11 numbers, which will then serve as the probability anchors for my <code>sample()</code> functions later on.</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb6-1"><a href="#cb6-1"></a><span class="co">## Generate skew inputs for sample probability</span></span>
<span id="cb6-2"><a href="#cb6-2"></a><span class="co">##</span></span>
<span id="cb6-3"><a href="#cb6-3"></a><span class="co">## `value1`, `value2` and `value3`</span></span>
<span id="cb6-4"><a href="#cb6-4"></a><span class="co">## generate the skewed probabilities</span></span>
<span id="cb6-5"><a href="#cb6-5"></a><span class="co">##</span></span>
<span id="cb6-6"><a href="#cb6-6"></a>skew_inputs &lt;-<span class="st"> </span><span class="cf">function</span>(value1, value2, value3){</span>
<span id="cb6-7"><a href="#cb6-7"></a>  </span>
<span id="cb6-8"><a href="#cb6-8"></a>  all_n &lt;-</span>
<span id="cb6-9"><a href="#cb6-9"></a><span class="st">  </span><span class="kw">c</span>(<span class="kw">rep</span>(value1, <span class="dv">7</span>), <span class="co"># 0 - 6</span></span>
<span id="cb6-10"><a href="#cb6-10"></a>    <span class="kw">rep</span>(value2, <span class="dv">2</span>), <span class="co"># 7 - 8</span></span>
<span id="cb6-11"><a href="#cb6-11"></a>    <span class="kw">rep</span>(value3, <span class="dv">2</span>)) <span class="co"># 9 - 10</span></span>
<span id="cb6-12"><a href="#cb6-12"></a>  </span>
<span id="cb6-13"><a href="#cb6-13"></a>  <span class="kw">return</span>(<span class="kw">sort</span>(all_n))</span>
<span id="cb6-14"><a href="#cb6-14"></a>}</span>
<span id="cb6-15"><a href="#cb6-15"></a></span>
<span id="cb6-16"><a href="#cb6-16"></a><span class="co">## Outcome KPI - NPS</span></span>
<span id="cb6-17"><a href="#cb6-17"></a>v_nps &lt;-</span>
<span id="cb6-18"><a href="#cb6-18"></a><span class="st">  </span>v_gender <span class="op">%&gt;%</span></span>
<span id="cb6-19"><a href="#cb6-19"></a><span class="st">  </span><span class="kw">map_dbl</span>(<span class="cf">function</span>(x){</span>
<span id="cb6-20"><a href="#cb6-20"></a>    <span class="cf">if</span>(x <span class="op">==</span><span class="st"> </span><span class="dv">1</span>){</span>
<span id="cb6-21"><a href="#cb6-21"></a></span>
<span id="cb6-22"><a href="#cb6-22"></a>      <span class="kw">sample</span>(<span class="dv">0</span><span class="op">:</span><span class="dv">10</span>, <span class="dt">size =</span> <span class="dv">1</span>, <span class="dt">prob =</span> <span class="kw">skew_inputs</span>(<span class="dv">1</span>, <span class="dv">1</span>, <span class="dv">8</span>))</span>
<span id="cb6-23"><a href="#cb6-23"></a></span>
<span id="cb6-24"><a href="#cb6-24"></a>    } <span class="cf">else</span> <span class="cf">if</span>(x <span class="op">==</span><span class="st"> </span><span class="dv">2</span>){</span>
<span id="cb6-25"><a href="#cb6-25"></a></span>
<span id="cb6-26"><a href="#cb6-26"></a>      <span class="kw">sample</span>(<span class="dv">0</span><span class="op">:</span><span class="dv">10</span>, <span class="dt">size =</span> <span class="dv">1</span>, <span class="dt">prob =</span> <span class="kw">skew_inputs</span>(<span class="dv">2</span>, <span class="dv">3</span>, <span class="dv">5</span>))</span>
<span id="cb6-27"><a href="#cb6-27"></a></span>
<span id="cb6-28"><a href="#cb6-28"></a>    } <span class="cf">else</span> <span class="cf">if</span>(x <span class="op">==</span><span class="st"> </span><span class="dv">3</span>){</span>
<span id="cb6-29"><a href="#cb6-29"></a></span>
<span id="cb6-30"><a href="#cb6-30"></a>      <span class="kw">sample</span>(<span class="dv">0</span><span class="op">:</span><span class="dv">10</span>, <span class="dt">size =</span> <span class="dv">1</span>, <span class="dt">prob =</span> <span class="kw">skew_inputs</span>(<span class="dv">1</span>, <span class="dv">3</span>, <span class="dv">6</span>))</span>
<span id="cb6-31"><a href="#cb6-31"></a></span>
<span id="cb6-32"><a href="#cb6-32"></a>    } <span class="cf">else</span> {</span>
<span id="cb6-33"><a href="#cb6-33"></a></span>
<span id="cb6-34"><a href="#cb6-34"></a>      <span class="kw">stop</span>(<span class="st">&quot;Error - check x&quot;</span>)</span>
<span id="cb6-35"><a href="#cb6-35"></a></span>
<span id="cb6-36"><a href="#cb6-36"></a>    }</span>
<span id="cb6-37"><a href="#cb6-37"></a>  }) <span class="op">%&gt;%</span></span>
<span id="cb6-38"><a href="#cb6-38"></a><span class="st">  </span><span class="kw">set_varl</span>(<span class="st">&quot;Q3. NPS&quot;</span>)</span></code></pre></div>
<p>Admittedly that the above procedure isn’t <em>minimal</em>, but note that this is a trade-off to introduce some arbitrary patterns to the data. A ‘quick and dirty’ alternative simulation would simply be to run <code>sample(x = 0:10, size = 1000, replace = TRUE)</code> for <code>v_nps</code>.</p>
<p>There is one slight technicality: the so-called NPS question is strictly speaking a <em>likelihood to recommend</em> question which ranges from 0 to 10, and the <strong>Net Promoter Score</strong> itself is calculated on a recoded version of that question where <em>Detractors</em> (scoring 0 to 6) have to be coded as -100, <em>Passives</em> (scoring 7 to 8) as 0, and <em>Promoters</em> (scoring 9 to 10) as +100. The <strong>Net Promoter Score</strong> is simply calculated as a mean of those recoded values.</p>
<p>Fortunately, the {surveytoolbox} package comes shipped with a <code>as_nps()</code> function that does this recoding for you, and also automatically applies the value labels. let’s call this new variable <code>v_nps2</code>:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1"></a><span class="co">## Outcome KPI - Recoded NPS (NPS2)</span></span>
<span id="cb7-2"><a href="#cb7-2"></a></span>
<span id="cb7-3"><a href="#cb7-3"></a>v_nps2 &lt;-<span class="st"> </span><span class="kw">as_nps</span>(v_nps) <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">set_varl</span>(<span class="st">&quot;Q3X. Recoded NPS&quot;</span>)</span></code></pre></div>
</div>
<div id="combine-vectors" class="section level2">
<h2>Combine vectors</h2>
<p>Now that all the individual variables are set up, I can simply combine them all into a tibble in one swift movement<a href="#fn4" class="footnote-ref" id="fnref4"><sup>4</sup></a>:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb8-1"><a href="#cb8-1"></a><span class="co">#### Combine individual vectors ####</span></span>
<span id="cb8-2"><a href="#cb8-2"></a>combined_df &lt;-</span>
<span id="cb8-3"><a href="#cb8-3"></a><span class="st">  </span><span class="kw">tibble</span>(<span class="dt">id =</span> v_id,</span>
<span id="cb8-4"><a href="#cb8-4"></a>         <span class="dt">gender =</span> v_gender,</span>
<span id="cb8-5"><a href="#cb8-5"></a>         <span class="dt">kpi =</span> v_kpi,</span>
<span id="cb8-6"><a href="#cb8-6"></a>         <span class="dt">nps =</span> v_nps,</span>
<span id="cb8-7"><a href="#cb8-7"></a>         <span class="dt">nps2 =</span> v_nps2)</span></code></pre></div>
</div>
<div id="results" class="section level2">
<h2>Results!</h2>
<div class="figure">
<img src="https://media.giphy.com/media/IgLnqEAUh3XP6dagEk/giphy.gif" alt="" />
<p class="caption">image from Giphy</p>
</div>
<p>Let’s run a few checks on our dataset to confirm that everything has worked out okay.</p>
<p>The classic {dplyr} <code>glimpse()</code>:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1"></a>combined_df <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">glimpse</span>()</span></code></pre></div>
<pre><code>## Observations: 1,000
## Variables: 5
## $ id     &lt;int&gt; 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 1...
## $ gender &lt;int+lbl&gt; 2, 2, 1, 2, 2, 1, 1, 2, 1, 2, 1, 1, 2, 2, 1, 1, 2, 2, 2,...
## $ kpi    &lt;dbl+lbl&gt; 3, 2, 5, 2, 5, 5, 2, 2, 5, 3, 3, 4, 1, 5, 4, 4, 4, 1, 2,...
## $ nps    &lt;dbl&gt; 10, 5, 10, 8, 10, 9, 7, 5, 2, 5, 1, 4, 5, 9, 9, 10, 9, 3, 10...
## $ nps2   &lt;dbl+lbl&gt; 100, -100, 100, 0, 100, 100, 0, -100, -100, -100, -100, ...</code></pre>
<p>Then <code>head()</code> to see the first five rows:</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb11-1"><a href="#cb11-1"></a>combined_df <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">head</span>()</span></code></pre></div>
<pre><code>## # A tibble: 6 x 5
##      id     gender                       kpi   nps             nps2
##   &lt;int&gt;  &lt;int+lbl&gt;                 &lt;dbl+lbl&gt; &lt;dbl&gt;        &lt;dbl+lbl&gt;
## 1     1 2 [Female] 3 [Neither]                  10  100 [Promoter] 
## 2     2 2 [Female] 2 [Somewhat dissatisfied]     5 -100 [Detractor]
## 3     3 1 [Male]   5 [Extremely satisfied]      10  100 [Promoter] 
## 4     4 2 [Female] 2 [Somewhat dissatisfied]     8    0 [Passive]  
## 5     5 2 [Female] 5 [Extremely satisfied]      10  100 [Promoter] 
## 6     6 1 [Male]   5 [Extremely satisfied]       9  100 [Promoter]</code></pre>
<p>So it appears that the value labels have been properly attached, and the range of values are what we’d expect. Now what about the “fake patterns”?</p>
<p>Looking at the topline result of the data, we seem to have succeeded in fabricating some sensible patterns in the data. It appears that this company X will need to work harder at winning over its female customers, who have rated them lower on two KPI metrics:</p>
<div class="sourceCode" id="cb13"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb13-1"><a href="#cb13-1"></a>combined_df <span class="op">%&gt;%</span></span>
<span id="cb13-2"><a href="#cb13-2"></a><span class="st">  </span><span class="kw">group_by</span>(gender) <span class="op">%&gt;%</span></span>
<span id="cb13-3"><a href="#cb13-3"></a><span class="st">  </span><span class="kw">summarise</span>(<span class="dt">n =</span> <span class="kw">n_distinct</span>(id),</span>
<span id="cb13-4"><a href="#cb13-4"></a>            <span class="dt">kpi =</span> <span class="kw">mean</span>(kpi),</span>
<span id="cb13-5"><a href="#cb13-5"></a>            <span class="dt">nps2 =</span> <span class="kw">mean</span>(nps2))</span></code></pre></div>
<pre><code>## # A tibble: 3 x 4
##       gender     n   kpi  nps2
##    &lt;int+lbl&gt; &lt;int&gt; &lt;dbl&gt; &lt;dbl&gt;
## 1 1 [Male]     490  3.49 31.0 
## 2 2 [Female]   464  3.07 -8.62
## 3 3 [Other]     46  3.15 17.4</code></pre>
</div>
<div id="check-the-labels" class="section level2">
<h2>Check the labels 🏷🏷🏷</h2>
<p>Finally I’d like to share a couple of functions that enable you to explore the labels in a labelled dataset. <code>surveytoolbox::varl_tb()</code> accepts a labelled data frame, and returns a two-column data frame with the variable name and its corresponding variable label:</p>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb15-1"><a href="#cb15-1"></a>combined_df <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">varl_tb</span>()</span></code></pre></div>
<pre><code>## # A tibble: 5 x 2
##   var    var_label        
##   &lt;chr&gt;  &lt;chr&gt;            
## 1 id     Record Identifier
## 2 gender Q1. Gender       
## 3 kpi    Q2. KPI          
## 4 nps    Q3. NPS          
## 5 nps2   Q3X. Recoded NPS</code></pre>
<p><code>surveytoolbox::data_dict()</code> takes this further, and shows also the value labels as a third column. This is what effectively what’s typically referred to as a <strong>code frame</strong> in a market research context:</p>
<div class="sourceCode" id="cb17"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb17-1"><a href="#cb17-1"></a>combined_df <span class="op">%&gt;%</span></span>
<span id="cb17-2"><a href="#cb17-2"></a><span class="st">  </span><span class="kw">select</span>(<span class="op">-</span>id) <span class="op">%&gt;%</span></span>
<span id="cb17-3"><a href="#cb17-3"></a><span class="st">  </span><span class="kw">data_dict</span>()</span></code></pre></div>
<pre><code>##      var        label_var
## 1 gender       Q1. Gender
## 2    kpi          Q2. KPI
## 3    nps          Q3. NPS
## 4   nps2 Q3X. Recoded NPS
##                                                                                label_val
## 1                                                                    Male; Female; Other
## 2 Extremely dissatisfied; Somewhat dissatisfied; Neither; Satisfied; Extremely satisfied
## 3                                                                                       
## 4                                            Detractor; Passive; Promoter; Missing value
##                              value
## 1                          1; 2; 3
## 2                    1; 2; 3; 4; 5
## 3 0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10
## 4                     -100; 0; 100</code></pre>
<p>I would also highly recommend the <code>view_df()</code> function from {sjPlot}, which exports a similar overview of variables and labels in a nicely formatted HTML table. For huge labelled datasets, this offers a fantastic light-weight way to browse through your variables and labels.</p>
<div class="sourceCode" id="cb19"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb19-1"><a href="#cb19-1"></a>combined_df <span class="op">%&gt;%</span><span class="st"> </span>sjPlot<span class="op">::</span><span class="kw">view_df</span>()</span></code></pre></div>
<p>Once we’ve checked all the labels and we’re happy with everything, we can then export our dataset with <code>haven::write_sav()</code>! If everything’s worked properly, all the labels should appear properly if you choose to open your example dataset in SPSS, or Q:</p>
<div class="sourceCode" id="cb20"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb20-1"><a href="#cb20-1"></a>combined_df <span class="op">%&gt;%</span><span class="st"> </span>haven<span class="op">::</span><span class="kw">write_sav</span>(<span class="st">&quot;Simulated Dataset.sav&quot;</span>)</span></code></pre></div>
</div>
<div id="end-notes" class="section level2">
<h2>End notes</h2>
<p>I hope you’ve found this vignette useful!</p>
<p>If you ever get a chance to try out <a href="https://www.github.com/martinctc/surveytoolbox">{surveytoolbox}</a>, I would really appreciate if you can submit any <a href="https://github.com/martinctc/surveytoolbox/issues">issues/feedback on GitHub</a>, or get in touch with me directly. I’m looking for collaborators to make the package more user-friendly and powerful, so if you’re interested, please don’t be shy and give me a shout! 😄</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>Check out <a href="https://community.rstudio.com/t/faq-whats-a-reproducible-example-reprex-and-how-do-i-do-one/5219">this RStudio Community thread</a> to learn more about <strong>reprex</strong> (the portmanteau <em>reprex</em> is coined by <a href="https://twitter.com/romain_francois/status/530011023743655936">Romain Francois</a>)<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
<li id="fn2"><p>If you’re not familiar with this concept / approach, I’d recommend checking out <a href="https://stackoverflow.com/questions/13605271/reasons-for-using-the-set-seed-function">this Stack Overflow thread</a>.<a href="#fnref2" class="footnote-back">↩︎</a></p></li>
<li id="fn3"><p>For those who are more ambitious, I would recommend checking out the <a href="https://cran.r-project.org/web/packages/uuid/index.html">{uuid} package</a> for generating proper GUIDs (Globally Unique Identifier). However, this then wouldn’t be <em>minimal</em>, so I would just stick with running a simple <code>seq()</code> sequence.<a href="#fnref3" class="footnote-back">↩︎</a></p></li>
<li id="fn4"><p>I shouldn’t need to footnote this, but here’s a Rocky Flintstone tribute for any Belinkers out there. 🤣<a href="#fnref4" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
