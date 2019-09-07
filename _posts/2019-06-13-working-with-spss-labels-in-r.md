---
title: "Working with SPSS labels in R"

author: "Martin Chan"
date: "June 13, 2019"
layout: post
tags: vignettes
---


<section class="main-content">
<div id="tldr" class="section level2">
<h2>TL;DR 📖</h2>
<p>This post provides an overview of R functions for dealing with survey data labels, particularly ones that I wish I’d known when I first started out analysing survey data in R. Some of these functions come from <a href="https://nicedoc.io/martinctc/surveytoolbox">surveytoolbox</a>, a package I’m developing (GitHub only) which contains a collection of my favourite / most frequently used R functions for analysing survey data. I also highly recommend checking out <a href="http://larmarange.github.io/labelled/">labelled</a>, <a href="https://strengejacke.github.io/sjlabelled/">sjlabelled</a>, and of course tidyverse’s own <a href="https://haven.tidyverse.org/">haven</a> package 📦.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/another-survey.jpg" width="50%" /></p>
<hr />
</div>
<div id="background" class="section level2">
<h2>Background</h2>
<p>Since a significant proportion of my typical analysis projects involves survey data, I’m always on the look out for new and better ways to improve my R analysis workflows for surveys. Funnily enough, when I first started out to use R a couple of years ago, I didn’t think R was at all intuitive or easy to work with survey data. Rather painful if I’m completely honest!</p>
<p>One of the big reasons for this “pain” was due to survey labels.<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a></p>
<p>Survey data generally cannot be analysed independently of the <strong>variable labels</strong> (e.g. <em>Q1. What is your gender?</em>) and <strong>value labels</strong> (e.g. 1 = <strong>Male</strong>, 2 = <strong>Female</strong>, 3 = <strong>Other</strong>, …), which is true in the case of <strong>categorical variables</strong>.</p>
<p>Even for ordinal Likert scale variables such as “<em>On a scale of 1 to 10, how much do you agree with…</em>”, the meaning of the value is highly dependent on the nuanced wording of the agree-disagree statement. For instance:</p>
<ol style="list-style-type: decimal">
<li>Respondents with a different classification within the survey (e.g. “full-time employees” vs “retirees”) may also have answered a statement that is worded slightly differently but their responses are reflected using a single variable in the data: for instance, employees may be asked about their satisfaction with their current employer in the survey, and retirees asked about their previous employer.</li>
<li>In my talk at the <a href="https://martinctc.github.io/downloads/EARL%202018%20-%20Swiss%20Army%20Knife%20for%20Market%20Research%20-%20Martin%20Chan%20-%2010%20September%202018.pdf#">EARL conference</a> last year, I also discussed a specific type of trade-off agreement question where any interpretation of the data is particularly sensitive to the value labels:</li>
</ol>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/trade-off-survey.PNG" width="80%" /></p>
<p>My experience was that the base <strong>data frame</strong> in R does not easily lend itself to work easily with these labels. A lot of merging, sorting, recoding etc. therefore is then necessary in order to turn the analysis into neat output contingency tables that you typically get via other specialist survey analysis software, like SPSS or <a href="https://www.qresearchsoftware.com/">Q</a>. Here’s an example (with completely made up numbers) of what I would typically need to produce as an output:</p>
<pre><code>## # A tibble: 3 x 3
##   `Q10 Top 2 Box Agree`                 `R Users Segmen~ `Python Users Seg~
##   &lt;chr&gt;                                 &lt;chr&gt;            &lt;chr&gt;             
## 1 Coding R is one of my hobbies         88.1%            60.0%             
## 2 I don&#39;t like to spend time in front ~ 40.5%            39.1%             
## 3 I would be inclined to quit my job i~ 70.1%            40.5%</code></pre>
<p>Of course, another big reason was my own ignorance of all the different methods and packages available out there at the time, which would have otherwise made a lot of this easier! 😛</p>
<p>This post provides a tour of the various functions (from different packages) that I wish I had known at the time. Despite the title, it’s not just about <strong>SPSS</strong>: there are plenty of other formats (e.g. SAS files) out there which carry variable and value labels, but I think this title is justified because:</p>
<ol style="list-style-type: decimal">
<li>Most people starting out on survey data analysis will tend to first come across SPSS files (.sav)</li>
<li>SPSS is still one of the most popular data formats for survey data</li>
<li>It’s a SPSS file that I will use as a demo in this post - and the importing functions which I will briefly go through are SPSS-specific</li>
</ol>
<hr />
</div>
<div id="lets-start" class="section level2">
<h2>Let’s start! 🚀</h2>
<p>Let us first load in all the packages that we’ll use in this post. For clarity, I will still make the package-source of the functions explicit (e.g. <code>labelled::val_label()</code>) so it’s easy to see where each function comes from. One of these packages <strong>surveytoolbox</strong> is my own and available on Github only, and if you’re interested you can install this by running <code>devtools::install_github("martinctc/surveytoolbox")</code>.</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb2-1" title="1"><span class="kw">library</span>(tidyverse)</a>
<a class="sourceLine" id="cb2-2" title="2"><span class="kw">library</span>(haven)</a>
<a class="sourceLine" id="cb2-3" title="3"><span class="kw">library</span>(sjlabelled)</a>
<a class="sourceLine" id="cb2-4" title="4"><span class="kw">library</span>(labelled) </a>
<a class="sourceLine" id="cb2-5" title="5"><span class="kw">library</span>(surveytoolbox) <span class="co"># install with devtools::install_github(&quot;martinctc/surveytoolbox&quot;)</span></a></code></pre></div>
<p>Since all I really needed is just an open-source, simple, and accessible SPSS / .sav dataset with variable and value labels that I could use for examples, I simply went online and found the first dataset that ticked these boxes. Not the most exciting - it’s the <strong>1991 General Social Survey</strong>, which is a nationally representative sample of adults in the United States. You can download the SAV file from the ARDA site <a href="http://www.thearda.com/Archive/Files/Downloads/GSS1991_DL2.asp">here</a>.</p>
<p><code>haven::read_sav()</code> is my favourite way of loading in SPSS files. In my experience, it rarely has any problems and is generally fast enough; it is also part of the <a href="https://haven.tidyverse.org/">tidyverse</a>. There are other alternatives such as <code>sjlabelled::read_spss()</code> and <code>foreign::read.spss()</code>, but <strong>haven</strong> is my personal recommendation - you can pick a favourite and have these available in your backpocket.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> Two points to note:</p>
<ol style="list-style-type: decimal">
<li><p><code>foreign::read.spss()</code> returns a list rather than a data frame or a tibble, which for me is less ideal for analysis.</p></li>
<li><p>Another method for importing SPSS files is <a href="https://github.com/leeper/rio">rio’s</a> <code>import()</code> function. I understand that this is just a wrapper around <strong>haven’s</strong> <code>read_sav()</code> function, so I won’t discuss this method here.</p></li>
</ol>
<p>Let’s load in the same SPSS file, using the different methods:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb3-1" title="1">file_path &lt;-<span class="st"> &quot;../datasets/General Social Survey_1991.SAV&quot;</span></a>
<a class="sourceLine" id="cb3-2" title="2"></a>
<a class="sourceLine" id="cb3-3" title="3">source_data_hv &lt;-<span class="st"> </span>haven<span class="op">::</span><span class="kw">read_sav</span>(file_path)</a>
<a class="sourceLine" id="cb3-4" title="4">source_data_sj &lt;-<span class="st"> </span>sjlabelled<span class="op">::</span><span class="kw">read_spss</span>(file_path)</a>
<a class="sourceLine" id="cb3-5" title="5">source_data_fo &lt;-<span class="st"> </span>foreign<span class="op">::</span><span class="kw">read.spss</span>(file_path)</a></code></pre></div>
<p>Running <code>glimpse()</code> on the first twenty rows of the imported data show that many variables are of the <strong>labelled double</strong> class (where it shows <code>&lt;dbl+lbl&gt;</code>) - meaning that these variables would have labels associated with the numeric values they hold. The numeric values alone us tell us nothing about what they represent, as these are likely to be categorical variables “in reality”.</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" title="1">source_data_hv <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># File read in using `haven::read_sav()`</span></a>
<a class="sourceLine" id="cb4-2" title="2"><span class="st">  </span>.[,<span class="dv">1</span><span class="op">:</span><span class="dv">20</span>] <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># First 20 columns</span></a>
<a class="sourceLine" id="cb4-3" title="3"><span class="st">  </span><span class="kw">glimpse</span>() </a></code></pre></div>
<pre><code>## Observations: 1,517
## Variables: 20
## $ YEAR     &lt;dbl+lbl&gt; 1991, 1991, 1991, 1991, 1991, 1991, 1991, 1991, 1...
## $ ID       &lt;dbl&gt; 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16...
## $ WRKSTAT  &lt;dbl+lbl&gt; 1, 2, 1, 1, 2, 8, 1, 6, 7, 1, 1, 7, 1, 1, 1, 7, 1...
## $ HRS1     &lt;dbl+lbl&gt; 40, 20, 50, 45, 20, NA, 40, NA, NA, 30, 40, NA, 4...
## $ HRS2     &lt;dbl&gt; NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ EVWORK   &lt;dbl+lbl&gt; NA, NA, NA, NA, NA, 2, NA, 1, 2, NA, NA, 1, NA, N...
## $ WRKSLF   &lt;dbl+lbl&gt; 2, 2, 2, 2, 2, NA, 1, 2, NA, 2, 2, 2, 2, 2, 2, NA...
## $ OCC80    &lt;dbl&gt; 453, 178, 7, 197, 447, NA, 999, 207, NA, 803, 723, 74...
## $ PRESTG80 &lt;dbl&gt; 22, 75, 59, 48, 42, NA, NA, 60, NA, 38, 36, 28, 65, 4...
## $ INDUS80  &lt;dbl&gt; 772, 841, 700, 800, 731, NA, 999, 832, NA, 632, 342, ...
## $ MARITAL  &lt;dbl+lbl&gt; 3, 1, 1, 5, 5, 5, 5, 4, 3, 1, 5, 1, 1, 5, 4, 1, 3...
## $ AGEWED   &lt;dbl+lbl&gt; 20, 24, 33, NA, NA, NA, NA, 21, 19, 25, NA, 23, 2...
## $ DIVORCE  &lt;dbl+lbl&gt; NA, 2, 2, NA, NA, NA, NA, NA, NA, 2, NA, 2, 2, NA...
## $ WIDOWED  &lt;dbl+lbl&gt; 2, 2, 2, NA, NA, NA, NA, 2, 2, 2, NA, 1, 2, NA, 2...
## $ SPWRKSTA &lt;dbl+lbl&gt; NA, 1, 7, NA, NA, NA, NA, NA, NA, 1, NA, 5, 1, NA...
## $ SPHRS1   &lt;dbl+lbl&gt; NA, 40, NA, NA, NA, NA, NA, NA, NA, 35, NA, NA, 4...
## $ SPHRS2   &lt;dbl+lbl&gt; NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ SPEVWORK &lt;dbl+lbl&gt; NA, NA, 1, NA, NA, NA, NA, NA, NA, NA, NA, 1, NA,...
## $ SPWRKSLF &lt;dbl+lbl&gt; NA, 1, 2, NA, NA, NA, NA, NA, NA, 2, NA, 2, 2, NA...
## $ SPOCC80  &lt;dbl&gt; NA, 13, 7, NA, NA, NA, NA, NA, NA, 6, NA, 417, 19, NA...</code></pre>
<p>Note that <code>haven::read_sav()</code> reads these labelled variables in as a class called <code>haven_labelled</code>, whilst <code>sjlabelled::read_spss()</code> would read these in as numeric variables containing label attributes. You can check this by running <code>class()</code> on one of the labelled variables.</p>
<p>Using <strong>haven</strong>:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1">source_data_hv<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">class</span>()</a></code></pre></div>
<pre><code>## [1] &quot;haven_labelled&quot;</code></pre>
<p>Using <strong>sjlabelled</strong>:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb8-1" title="1">source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">class</span>()</a></code></pre></div>
<pre><code>## [1] &quot;numeric&quot;</code></pre>
<p>Running <code>attr()</code> whilst specifying “labels” shows that both methods of reading the SPSS file return variables that contain value label attributes. Note that specifying “label<strong>s</strong>” (with an <em>s</em>) typically returns value labels, whereas “label” (no <em>s</em>) would return the variable labels.</p>
<p>Viewing <strong>value</strong> labels for data imported using <strong>haven</strong>:</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb10-1" title="1">source_data_hv<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">attr</span>(<span class="st">&#39;labels&#39;</span>)</a></code></pre></div>
<pre><code>##       Married       Widowed      Divorced     Separated Never married 
##             1             2             3             4             5</code></pre>
<p>Viewing <strong>value</strong> labels for data imported using <strong>sjlabelled</strong>:</p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb12-1" title="1">source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">attr</span>(<span class="st">&#39;labels&#39;</span>)</a></code></pre></div>
<pre><code>##       Married       Widowed      Divorced     Separated Never married 
##             1             2             3             4             5</code></pre>
<p>Viewing <strong>variable</strong> labels for data imported using <strong>haven</strong>:</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb14-1" title="1">source_data_hv<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">attr</span>(<span class="st">&#39;label&#39;</span>)</a></code></pre></div>
<pre><code>## [1] &quot;Are you currently -- married, widowed, divorced, separated, or have you never been married?&quot;</code></pre>
<p>Viewing <strong>variable</strong> labels for data imported using <strong>sjlabelled</strong>:</p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb16-1" title="1">source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">attr</span>(<span class="st">&#39;label&#39;</span>)</a></code></pre></div>
<pre><code>## [1] &quot;Are you currently -- married, widowed, divorced, separated, or have you never been married?&quot;</code></pre>
<p>As you can see, there are no differences in the labels returned whether the data is imported using <strong>haven</strong> or <strong>sjlabelled</strong>.</p>
<p>It’s also worth noting that various different packages have similar methods for extracting variable and value labels - which practically do the same thing:</p>
<div class="sourceCode" id="cb18"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb18-1" title="1"><span class="kw">list</span>(</a>
<a class="sourceLine" id="cb18-2" title="2">  <span class="st">&quot;labelled::var_label()&quot;</span> =<span class="st"> </span>source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span>labelled<span class="op">::</span><span class="kw">var_label</span>(),</a>
<a class="sourceLine" id="cb18-3" title="3">  <span class="st">&quot;sjlabelled::get_label()&quot;</span> =<span class="st"> </span>source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span>sjlabelled<span class="op">::</span><span class="kw">get_label</span>(),</a>
<a class="sourceLine" id="cb18-4" title="4">  <span class="st">&quot;attr()&quot;</span> =<span class="st"> </span>source_data_sj<span class="op">$</span>MARITAL <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">attr</span>(<span class="dt">which =</span> <span class="st">&quot;label&quot;</span>)</a>
<a class="sourceLine" id="cb18-5" title="5">)</a></code></pre></div>
<pre><code>## $`labelled::var_label()`
## [1] &quot;Are you currently -- married, widowed, divorced, separated, or have you never been married?&quot;
## 
## $`sjlabelled::get_label()`
## [1] &quot;Are you currently -- married, widowed, divorced, separated, or have you never been married?&quot;
## 
## $`attr()`
## [1] &quot;Are you currently -- married, widowed, divorced, separated, or have you never been married?&quot;</code></pre>
<hr />
</div>
<div id="exploring-labels-in-the-dataset" class="section level2">
<h2>Exploring labels in the dataset 🔎</h2>
<p>For the subsequent examples, I’ll only reference the tibble returned with <strong>haven::read_sav()</strong> for simplicity.</p>
<p>Before you perform any analysis, it’s necessary to first explore what variables and variable codes (value labels) are available in the data, which is needed if you do not have the original questionnaire. Here are several of my favourite functions:</p>
<ol style="list-style-type: decimal">
<li><code>sjPlot::view_df()</code></li>
<li><code>surveytoolbox::varl_tb()</code></li>
<li><code>surveytoolbox::extract_vallab()</code></li>
<li><code>labelled::look_for()</code></li>
</ol>
<div class="sourceCode" id="cb20"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb20-1" title="1">source_data_hv <span class="op">%&gt;%</span><span class="st"> </span>sjPlot<span class="op">::</span><span class="kw">view_df</span>()</a></code></pre></div>
<div id="sjplotview_df" class="section level3">
<h3><code>sjPlot::view_df()</code></h3>
<p>The <code>view_df()</code> function from the <strong>sjPlot</strong> package returns a pretty HTML document that, by default, contains a table that details the following for all the variables in the data:</p>
<ul>
<li>Variable name</li>
<li>Variable label</li>
<li>Value range / Values</li>
<li>Value labels</li>
</ul>
<p>Here’s a screenshot of the generated document: <img src="{{ site.url }}{{ site.baseurl }}/images/view_df-example.PNG" width="80%" /></p>
<p>Check out this link to see a full example of what’s generated with the function:</p>
<p><a href="https://martinctc.github.io/examples/sjPlot_view_df.html">Click here</a></p>
<p>The documentation for <code>view_df()</code> also states that you can show percentages and frequencies for each variable, which is a pretty nifty feature for exploring a dataset.</p>
</div>
<div id="surveytoolboxvarl_tb" class="section level3">
<h3><code>surveytoolbox::varl_tb()</code></h3>
<p>But what if you wished to extract individual labels for further formatting / analysis?</p>
<p>The <code>varl_tb()</code> from the <a href="https://www.github.com/martinctc/surveytoolbox">surveytoolbox</a> allows you to export variable names and their labels, returning a tidy data frame. This provides a convenient way of extracting labels if there is a desire to run string manipulation operations on the labels to be used for something else. This is what the output looks like if you run <code>varl_tb()</code> on the first twenty columns of our dataset:</p>
<div class="sourceCode" id="cb21"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb21-1" title="1"><span class="co">## NOT RUN - USE THIS TO INSTALL THE surveytoolbox PACKAGE</span></a>
<a class="sourceLine" id="cb21-2" title="2"><span class="co"># devtools::install_github(&quot;martinctc/surveytoolbox&quot;) </span></a>
<a class="sourceLine" id="cb21-3" title="3"></a>
<a class="sourceLine" id="cb21-4" title="4">source_data_hv <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb21-5" title="5"><span class="st">  </span>.[,<span class="dv">1</span><span class="op">:</span><span class="dv">20</span>] <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb21-6" title="6"><span class="st">  </span><span class="kw">varl_tb</span>()</a></code></pre></div>
<pre><code>## # A tibble: 20 x 2
##    var      var_label                                                      
##    &lt;chr&gt;    &lt;chr&gt;                                                          
##  1 YEAR     Year of survey                                                 
##  2 ID       Respondent original ID Number                                  
##  3 WRKSTAT  Last week were you working full-time, part-time, going to scho~
##  4 HRS1     If working, full or part-time: How many hours did you work las~
##  5 HRS2     If with a job, but not at work: How many hours a week do you u~
##  6 EVWORK   If retired, in school, keeping house, or other: Did you ever w~
##  7 WRKSLF   (Are/Were) you self-employed or (do/did) you work for someone ~
##  8 OCC80    Respondent&#39;s occupation (See Note 1: Occupational Codes and Pr~
##  9 PRESTG80 Prestige of respondent&#39;s occupation (See Note 1: Occupational ~
## 10 INDUS80  Respondent&#39;s industry (See Note 2: Industrial Classification o~
## 11 MARITAL  Are you currently -- married, widowed, divorced, separated, or~
## 12 AGEWED   If ever married: How old were you when you first married?      
## 13 DIVORCE  If currently married or widowed: Have you ever been divorced o~
## 14 WIDOWED  If currently married, separated, or divorced: Have you ever be~
## 15 SPWRKSTA Last week was your (wife/husband) working full-time, part-time~
## 16 SPHRS1   If working, full or part-time: How many hours did (he/she) wor~
## 17 SPHRS2   If with a job, but not at work: How many hours a week does (he~
## 18 SPEVWORK If spouse retired, in school, keeping house, or other: Did (he~
## 19 SPWRKSLF (Is/Was) (he/she) self-employed or (does/did) (he/she) work fo~
## 20 SPOCC80  Respondent&#39;s spouse&#39;s occupation (See Note 1: Occupational Cod~</code></pre>
<p>The additional benefit of this function is that this is all magrittr-pipe optimised, so this fits perfectly with a dplyr-oriented workflow.</p>
</div>
<div id="surveytoolboxextract_vallab" class="section level3">
<h3><code>surveytoolbox::extract_vallab()</code></h3>
<p>If you’re interested in extracting individual value labels, another method is available within <strong>surveytoolbox</strong> through <code>extract_vallab()</code>. This is easy: simply enter the variable name as the second argument (as a string):</p>
<div class="sourceCode" id="cb23"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb23-1" title="1">source_data_hv <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb23-2" title="2"><span class="st">  </span><span class="kw">extract_vallab</span>(<span class="st">&quot;WRKSTAT&quot;</span>)</a></code></pre></div>
<pre><code>## # A tibble: 8 x 2
##      id WRKSTAT                                                            
##   &lt;dbl&gt; &lt;chr&gt;                                                              
## 1     1 Working full-time                                                  
## 2     2 Working part-time                                                  
## 3     3 With a job, but not at work because of temporary illness, vacation~
## 4     4 Unemployed, laid off, looking for work                             
## 5     5 Retired                                                            
## 6     6 In school                                                          
## 7     7 Keeping house                                                      
## 8     8 Other</code></pre>
<p>You can then use the output from <code>extract_vallab()</code> for joining / editing labels with analysis outputs if needed.</p>
</div>
<div id="labelledlook_for" class="section level3">
<h3><code>labelled::look_for()</code></h3>
<p>But what if you’re not sure about the exact variable names, but you know roughly what’s in the variable label (typically, survey question text)? <code>labelled::look_for()</code> provides a pipe-optimised method that allows you to search into both variable names and variable label descriptions. Say for instance we want to identify a variable relating to <em>household income deficit</em>, where “income deficit” are the keywords. The <code>look_for()</code> function then returns a data frame with a “variable” column and a “label” column:</p>
<div class="sourceCode" id="cb25"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb25-1" title="1">source_data_hv <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb25-2" title="2"><span class="st">  </span>labelled<span class="op">::</span><span class="kw">look_for</span>(<span class="st">&quot;income deficit&quot;</span>)</a></code></pre></div>
<pre><code>##     variable                       label
## 644   INCDEF Income deficit of household</code></pre>
<p>You can then very easily browse the value labels of <code>INCDEF</code> with <code>surveytoolbox::extract_vallab()</code>:</p>
<div class="sourceCode" id="cb27"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb27-1" title="1">source_data_hv <span class="op">%&gt;%</span></a>
<a class="sourceLine" id="cb27-2" title="2"><span class="st">  </span>surveytoolbox<span class="op">::</span><span class="kw">extract_vallab</span>(<span class="st">&quot;INCDEF&quot;</span>)</a></code></pre></div>
<pre><code>## # A tibble: 8 x 2
##      id INCDEF             
##   &lt;dbl&gt; &lt;chr&gt;              
## 1     1 -$10,000           
## 2     2 -$10,000 to -$5,000
## 3     3 -$4,999 to -$1,000 
## 4     4 -$999 to +$999     
## 5     5 +$1,000 to $4,999  
## 6     6 +$5,000 to +$10,000
## 7     7 +$10,000           
## 8     8 $20,000 +</code></pre>
<hr />
</div>
</div>
<div id="to-be-continued.." class="section level2">
<h2>To be continued..!</h2>
<p>Working with survey data labels is itself a pretty big subject (surprisingly), and this post has only very much just scraped the surface. For instance, <strong>factors</strong> is another subject that deserves exploration, as they are the standard R class for working with categorical data. A quick Google search will reveal more packages that allow you to deal with labels, such as <a href="https://gdemin.github.io/expss/">expss</a>, which I haven’t used before. It’s typically a valuable exercise anyway to compare and benchmark different methods on consistency, versatility, and speed - as this will inform you on which method will likely work best for your workflow. Therefore there will (probably) be a part 2 to this post!</p>
<p>The good and bad thing about R is there are often many ways to do a similar thing (see this <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/">discussion</a>), and therefore it’s often useful to compare and contrast functions from different packages that do similar things. The functions discussed in this post is what I’ve personally found to work well with my own workflow / code, and by no means is this an exhaustive, comprehensive survey of methods!</p>
<p>I very much would like to hear any comments / feedback that you have with either the content on this blog or with the <a href="https://nicedoc.io/martinctc/surveytoolbox">surveytoolbox</a> package. Thank you!</p>
<p>If you’ve got some spare time, please have a read of this additional footnote <a href="#fn3" class="footnote-ref" id="fnref3"><sup>3</sup></a> on why it took me slightly longer to publish this post.</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>In this post, the focus of the dicussion would be more on labelled vectors than <em>factors</em>; in line with the principle listed in <strong>haven</strong>’s <a href="https://haven.tidyverse.org/reference/labelled.html">documentation on the labelled function</a>, the best practice is to analyse the data using a standard R class, but knowing how to deal with labels is useful at the importing / data checking stage.<a href="#fnref1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p>See <a href="https://www.r-bloggers.com/working-with-spss-data-in-r/">this</a> blog post for a more in-depth discussion on the differences<a href="#fnref2" class="footnote-back">↩</a></p></li>
<li id="fn3"><p>I had planned to finish this post earlier in the week, but distressing news from my home city Hong Kong has diverted my attention. In the past week, a million Hong Kongers had been peacefully protesting against a bill which will enable extradition to mainland China, which has a record of <a href="https://www.bbc.com/news/world-asia-34782266">questionable judicial processes</a>. In the last 1-2 days, this peaceful process has turned violent with the government first declaring the protest as a ‘riot’ based on a small minority of resistance, then with the <a href="https://twitter.com/racsiw5/status/1138873714601353217">police injuring defenseless citizens with rubber bullet and tear gas rounds</a>, with students and people I know amongst the victims. I want to express support for those are still peacefully resisting on the streets as I write, and to hopefully raise awareness of what is happening in Hong Kong to everyone around the world. Please check out this <a href="https://www.theguardian.com/world/2019/jun/10/what-are-the-hong-kong-protests-about-explainer">explainer</a> by the Guardian to find out more.<a href="#fnref3" class="footnote-back">↩</a></p></li>
</ol>
</div>
</section>
