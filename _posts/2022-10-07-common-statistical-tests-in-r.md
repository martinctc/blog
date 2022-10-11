---
title: "Common Statistical Tests in R"

author: "Martin Chan"
date: "October 7, 2022"
layout: post
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/header-attrs-2.16/header-attrs.js"></script>

<section class="main-content">
<div id="introduction" class="section level1">
<h1>Introduction</h1>
<p>This post will focus on common statistical tests in R that you can
perform to understand and validate the relationship between two
variables.</p>
<p>Very statistics 101, you may be thinking. So why? This post is edited
from my own notes from learning statistics and R. The primary goal of
the post is to be practical enough for myself to refer to from time to
time, as I do for all my other tutorials/posts in this blog. The
secondary goal is that hopefully, as a side effect, that this post will
benefit others who are learning statistics and R too.</p>
<p>To illustrate the R code, I will also be using a sample dataset
<code>pq_data</code> from the package <a
href="https://microsoft.github.io/vivainsights/"><strong>vivainsights</strong></a>,
which is a cross-sectional time-series dataset measuring the
collaboration behaviour of simulated employees in an organization. Each
row represents an employee on a certain week, with columns measuring
behaviours such as total weekly time spent in email, meetings, chats,
and so on.</p>
<p>A note about the structure of this post: in the real world, one
should always as best practice visually check the data distribution and
run tests for assumptions like normality and homoscedasticity prior to
performing any tests. This best practice isn’t really observed in this
post for the sake of covering the widest range of scenarios. Hence,
please be forgiving when you see that the narrative runs ‘head first’
into a test without examining the data - and avoid this in real
life!</p>
</div>
<div id="loading-the-dataset" class="section level1">
<h1>Loading the dataset</h1>
<p>The package <strong>vivainsights</strong> is available on CRAN, so
you can install this with
<code>install.packages("vivainsights")</code>.</p>
<p>You can load the dataset in R by calling <code>pq_data</code> after
loading the <strong>vivainsights</strong> package. Here is a preview of
the first ten columns of the dataset using
<code>dplyr::glimpse()</code>:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(vivainsights)</span>
<span id="cb1-2"><a href="#cb1-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb1-3"><a href="#cb1-3" aria-hidden="true" tabindex="-1"></a><span class="fu">glimpse</span>(pq_data[, <span class="dv">1</span><span class="sc">:</span><span class="dv">10</span>])</span></code></pre></div>
<pre><code>## Rows: 5,593
## Columns: 10
## $ PersonId                           &lt;chr&gt; &quot;2b625906-1f36-3273-8d0d-13e714c5f6~
## $ MetricDate                         &lt;date&gt; 2021-12-26, 2021-12-26, 2021-12-26~
## $ After_hours_call_hours             &lt;dbl&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
## $ After_hours_chat_hours             &lt;dbl&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
## $ After_hours_collaboration_hours    &lt;dbl&gt; 7.6624994, 2.4908612, 0.1625000, 1.~
## $ After_hours_email_hours            &lt;dbl&gt; 0.2600000, 0.5883611, 0.1625000, 0.~
## $ After_hours_meeting_hours          &lt;dbl&gt; 7.50, 2.00, 0.00, 1.25, 19.00, 0.25~
## $ After_hours_scheduled_call_hours   &lt;dbl&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
## $ After_hours_unscheduled_call_hours &lt;dbl&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~
## $ Call_hours                         &lt;dbl&gt; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,~</code></pre>
<p>This tutorial also uses functions from <strong>tidyverse</strong>, so
ensure that you run <code>library(tidyverse)</code> to reproduce the
example outputs.</p>
</div>
<div id="understanding-the-relation-between-two-variables"
class="section level1">
<h1>Understanding the relation between two variables</h1>
<p>One of the most basic tasks in statistics and data science is to
understand the relation between two variables. Sometimes the motivation
is understand whether the relationship is causal, but this is not always
the case (for instance, one may simply wish to test for
multicollinearity when selecting predictors for a model).</p>
<p>In our dataset, we have two metrics of interest: -
<code>Multitasking_hours</code> measures the total number of hours the
person spent sending emails or instant messages during a meeting or a
Teams call. - <code>After_hours_collaboration_hours</code> measures the
number of hours a person has spent in collaboration (meetings, emails,
IMs, and calls) outside of working hours.<a href="#fn1"
class="footnote-ref" id="fnref1"><sup>1</sup></a></p>
<p>Imagine then we have two questions to address:</p>
<ol style="list-style-type: decimal">
<li><p>We suspect that multitasking hours is correlated with after-hours
working, as the former could be a symptom of excessive workload or
sub-optimal time management which can explain after-hours working. What
can we do to understand the relationship between the two?</p></li>
<li><p>Do <em>managers</em> multi-task more than <em>senior individual
contributors (IC)</em>?</p></li>
</ol>
<p>To answer these questions, there are a couple of common methods at
our disposal. Here is a (non-exhaustive) list:</p>
<ul>
<li>Comparison tests</li>
<li>Correlation tests</li>
<li>Regression tests</li>
<li>Effect Size</li>
<li>Statistical power</li>
<li>Sample variability</li>
</ul>
<p>It is worth noting that the first question postulates a relation
between two <strong>continuous</strong> variables (multitasking hours,
afterhours collaboration), whereas the second question a relation
between a <strong>categorical</strong> variable (manager/ senior IC) and
a <strong>continuous</strong> variable (multitasking hours). The types
of the variables in question help determine which tests are
appropriate.</p>
<p>The categorical variable that provides us information on whether an
employee is a manager or a senior IC in <code>pq_data</code> is stored
in <code>LevelDesignation</code>. We can use
<code>vivainsights::hrvar_count()</code> to explore this variable:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="fu">hrvar_count</span>(pq_data, <span class="at">hrvar =</span> <span class="st">&quot;LevelDesignation&quot;</span>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/figure-html/unnamed-chunk-3-1.png" /><!-- --></p>
<div id="comparison-tests" class="section level2">
<h2>Comparison tests</h2>
<p>Two of the most common comparison tests would be the
<strong>t-test</strong> and <strong>Analysis of Variance
(ANOVA)</strong>.</p>
<p>A t-test can be paired or unpaired, where the former is used for
comparing the means of two groups in the same population, and the latter
for independent samples from two populations or groups. An unpaired
(two-sample) t-test is therefore appropriate for the scenario in
question two, as managers and ICs are two different populations.</p>
<p>Since we are interested in the difference between managers and senior
ICs, we will first need to create a factor variable from the data that
has only two levels. In the below code, we will first filter out any
values of <code>LevelDesignation</code> that are not
<code>"Manager"</code> and <code>"Senior IC"</code>, and create a new
factor column as <code>ManagerIndicator</code>:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true" tabindex="-1"></a>pq_data_grouped <span class="ot">&lt;-</span></span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true" tabindex="-1"></a>  pq_data <span class="sc">%&gt;%</span></span>
<span id="cb4-3"><a href="#cb4-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(LevelDesignation <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Manager&quot;</span>, <span class="st">&quot;Senior IC&quot;</span>)) <span class="sc">%&gt;%</span></span>
<span id="cb4-4"><a href="#cb4-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(</span>
<span id="cb4-5"><a href="#cb4-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">ManagerIndicator =</span></span>
<span id="cb4-6"><a href="#cb4-6" aria-hidden="true" tabindex="-1"></a>      <span class="fu">factor</span>(LevelDesignation,</span>
<span id="cb4-7"><a href="#cb4-7" aria-hidden="true" tabindex="-1"></a>      <span class="at">levels =</span> <span class="fu">c</span>(<span class="st">&quot;Manager&quot;</span>, <span class="st">&quot;Senior IC&quot;</span>))</span>
<span id="cb4-8"><a href="#cb4-8" aria-hidden="true" tabindex="-1"></a>  )</span></code></pre></div>
<p>Recall also that our dataset <code>pq_data</code> is a
cross-sectional time-series dataset, which means that for every
individual identified by <code>PersonId</code>, there will be multiple
rows corresponding to different dates. To simplify the dataset so that
we are looking at person averages, we can group the dataset by
<code>PersonId</code> and calculate the mean of
<code>Multitasking_hours</code>. After this manipulation,
<code>Multitasking_hours</code> would represent the mean multitasking
hours <em>per person</em>, as opposed to <em>per person per week</em>.
Let us do this by extending the pipe:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true" tabindex="-1"></a>pq_data_grouped <span class="ot">&lt;-</span></span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true" tabindex="-1"></a>  pq_data <span class="sc">%&gt;%</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(LevelDesignation <span class="sc">%in%</span> <span class="fu">c</span>(<span class="st">&quot;Manager&quot;</span>, <span class="st">&quot;Senior IC&quot;</span>)) <span class="sc">%&gt;%</span></span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(</span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">ManagerIndicator =</span></span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true" tabindex="-1"></a>      <span class="fu">factor</span>(LevelDesignation,</span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true" tabindex="-1"></a>      <span class="at">levels =</span> <span class="fu">c</span>(<span class="st">&quot;Manager&quot;</span>, <span class="st">&quot;Senior IC&quot;</span>))</span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">%&gt;%</span></span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">group_by</span>(PersonId, ManagerIndicator) <span class="sc">%&gt;%</span></span>
<span id="cb5-10"><a href="#cb5-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">summarise</span>(<span class="at">Multitasking_hours =</span> <span class="fu">mean</span>(Multitasking_hours), <span class="at">.groups =</span> <span class="st">&quot;drop&quot;</span>)</span>
<span id="cb5-11"><a href="#cb5-11" aria-hidden="true" tabindex="-1"></a>  </span>
<span id="cb5-12"><a href="#cb5-12" aria-hidden="true" tabindex="-1"></a><span class="fu">glimpse</span>(pq_data_grouped)</span></code></pre></div>
<pre><code>## Rows: 56
## Columns: 3
## $ PersonId           &lt;chr&gt; &quot;00f6d464-ba1f-31ee-b51e-ab6e8ec4fb79&quot;, &quot;023ddb61-1~
## $ ManagerIndicator   &lt;fct&gt; Senior IC, Manager, Senior IC, Senior IC, Manager, ~
## $ Multitasking_hours &lt;dbl&gt; 0.2813373, 0.5980080, 0.3319752, 0.2938879, 0.70762~</code></pre>
<p>Now our data is in the right format. Let us assume that the data
satisfies all the assumptions of the t-test, and see what happens when
we run it with the base <code>t.test()</code> function:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1" aria-hidden="true" tabindex="-1"></a><span class="fu">t.test</span>(</span>
<span id="cb7-2"><a href="#cb7-2" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb7-3"><a href="#cb7-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped,</span>
<span id="cb7-4"><a href="#cb7-4" aria-hidden="true" tabindex="-1"></a>  <span class="at">paired =</span> <span class="cn">FALSE</span></span>
<span id="cb7-5"><a href="#cb7-5" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<pre><code>## 
##  Welch Two Sample t-test
## 
## data:  Multitasking_hours by ManagerIndicator
## t = 10.097, df = 28.758, p-value = 5.806e-11
## alternative hypothesis: true difference in means between group Manager and group Senior IC is not equal to 0
## 95 percent confidence interval:
##  0.3444870 0.5195712
## sample estimates:
##   mean in group Manager mean in group Senior IC 
##               0.8103354               0.3783063</code></pre>
<p>In the function, the predictor and outcome variables are supplied
using a tilde (<code>~</code>) format common in R, and we have specified
<code>paired = FALSE</code> to use an unpaired t-test. As for the
output,</p>
<ul>
<li><code>t</code> represents the t-statistic.</li>
<li><code>df</code> represents the degree of freedom.</li>
<li><code>p-value</code> is - well - the p-value. The value here shows
to be significant, as it is smaller than the significance level at
0.05.</li>
<li>the test allows us to reject the null hypothesis that the means of
multitasking hours between managers and ICs are the same.</li>
</ul>
<p>Note that the t-test used here is the <strong>Welch’s
t-test</strong>, which is an adaptation of the classic <strong>Student’s
t-test</strong> in that it compares the variance of the two groups,
i.e. handling heteroscedasticity.</p>
<div id="testing-for-normality" class="section level3">
<h3>Testing for normality</h3>
<p>But hang on!</p>
<p>There are several assumptions behind the unpaired classic t-test,
notably:</p>
<ol style="list-style-type: decimal">
<li>independence (sample is independent)</li>
<li>normality (data is normally distributed)</li>
<li>homoscedasticity (data across samples have equal variance)</li>
</ol>
<p>We can at least be sure of (1), as we know that senior ICs and
Managers are separate populations. However, (2) and (3) are assumptions
that we have to validate specifically. To test whether our data is
normally distributed, we can use the <strong>Shapiro-Wilk test of
normality</strong>, with the function <code>shapiro.test()</code>:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true" tabindex="-1"></a>pq_data_grouped <span class="sc">%&gt;%</span></span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">group_by</span>(ManagerIndicator) <span class="sc">%&gt;%</span></span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">summarise</span>(</span>
<span id="cb9-4"><a href="#cb9-4" aria-hidden="true" tabindex="-1"></a>    <span class="at">p =</span> <span class="fu">shapiro.test</span>(Multitasking_hours)<span class="sc">$</span>p.value,</span>
<span id="cb9-5"><a href="#cb9-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">statistic =</span> <span class="fu">shapiro.test</span>(Multitasking_hours)<span class="sc">$</span>statistic</span>
<span id="cb9-6"><a href="#cb9-6" aria-hidden="true" tabindex="-1"></a>  )</span></code></pre></div>
<pre><code>## # A tibble: 2 x 3
##   ManagerIndicator      p statistic
##   &lt;fct&gt;             &lt;dbl&gt;     &lt;dbl&gt;
## 1 Manager          0.146      0.936
## 2 Senior IC        0.0722     0.941</code></pre>
<p>As both p-values show up as less than 0.05, the test implies that we
should reject the null hypothesis that the data are normally distributed
(i.e. not normally distributed). To confirm, you can also perform a
visual check for normality using a histogram or a Q-Q plot.</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb11-1"><a href="#cb11-1" aria-hidden="true" tabindex="-1"></a><span class="co"># Multitasking hours - IC</span></span>
<span id="cb11-2"><a href="#cb11-2" aria-hidden="true" tabindex="-1"></a>mth_ic <span class="ot">&lt;-</span></span>
<span id="cb11-3"><a href="#cb11-3" aria-hidden="true" tabindex="-1"></a>  pq_data_grouped <span class="sc">%&gt;%</span></span>
<span id="cb11-4"><a href="#cb11-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(ManagerIndicator <span class="sc">==</span> <span class="st">&quot;Senior IC&quot;</span>) <span class="sc">%&gt;%</span></span>
<span id="cb11-5"><a href="#cb11-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">pull</span>(Multitasking_hours) </span>
<span id="cb11-6"><a href="#cb11-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb11-7"><a href="#cb11-7" aria-hidden="true" tabindex="-1"></a><span class="fu">qqnorm</span>(mth_ic, <span class="at">pch =</span> <span class="dv">1</span>, <span class="at">frame =</span> <span class="cn">FALSE</span>)</span>
<span id="cb11-8"><a href="#cb11-8" aria-hidden="true" tabindex="-1"></a><span class="fu">qqline</span>(mth_ic, <span class="at">col =</span> <span class="st">&quot;steelblue&quot;</span>, <span class="at">lwd =</span> <span class="dv">2</span>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/figure-html/unnamed-chunk-8-1.png" /><!-- --></p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true" tabindex="-1"></a><span class="co"># Multitasking hours - Manager</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true" tabindex="-1"></a>mth_man <span class="ot">&lt;-</span></span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true" tabindex="-1"></a>  pq_data_grouped <span class="sc">%&gt;%</span></span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(ManagerIndicator <span class="sc">==</span> <span class="st">&quot;Manager&quot;</span>) <span class="sc">%&gt;%</span></span>
<span id="cb12-5"><a href="#cb12-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">pull</span>(Multitasking_hours) </span>
<span id="cb12-6"><a href="#cb12-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb12-7"><a href="#cb12-7" aria-hidden="true" tabindex="-1"></a><span class="fu">qqnorm</span>(mth_man, <span class="at">pch =</span> <span class="dv">1</span>, <span class="at">frame =</span> <span class="cn">FALSE</span>)</span>
<span id="cb12-8"><a href="#cb12-8" aria-hidden="true" tabindex="-1"></a><span class="fu">qqline</span>(mth_man, <span class="at">col =</span> <span class="st">&quot;steelblue&quot;</span>, <span class="at">lwd =</span> <span class="dv">2</span>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/figure-html/unnamed-chunk-8-2.png" /><!-- --></p>
<p>As our data isn’t as normal as we would wish it to be - this makes
the unpaired t-test less appropriate or conclusive, and we can consider
other alternatives such as the <strong>non-parametric two-samples
Wilcoxon Rank-Sum test</strong>. This is covered further down below.</p>
</div>
<div id="testing-for-equality-of-variance-homoscedasticity"
class="section level3">
<h3>Testing for equality of variance (homoscedasticity)</h3>
<p>Asides from normality, another assumption of the t-test that we
didn’t properly test for prior to running <code>t.test()</code> is to
check for equality of variance across the two groups (homoscedasticity).
Thankfully, this was not something we had to worry about as we used the
Welch’s t-test; recall that the classic Student’s t-test assumes
equality between the two variances, but the Welch’s t-test takes the
difference into account.</p>
<p>Regardless, here is an example on how you can test for
homoscedasticity in R, using <code>var.test()</code>:</p>
<div class="sourceCode" id="cb13"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb13-1"><a href="#cb13-1" aria-hidden="true" tabindex="-1"></a><span class="co"># F test to compare two variances</span></span>
<span id="cb13-2"><a href="#cb13-2" aria-hidden="true" tabindex="-1"></a><span class="fu">var.test</span>(</span>
<span id="cb13-3"><a href="#cb13-3" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb13-4"><a href="#cb13-4" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped</span>
<span id="cb13-5"><a href="#cb13-5" aria-hidden="true" tabindex="-1"></a>  )</span></code></pre></div>
<pre><code>## 
##  F test to compare two variances
## 
## data:  Multitasking_hours by ManagerIndicator
## F = 4.5726, num df = 22, denom df = 32, p-value = 0.0001085
## alternative hypothesis: true ratio of variances is not equal to 1
## 95 percent confidence interval:
##   2.146082 10.318237
## sample estimates:
## ratio of variances 
##           4.572575</code></pre>
<p>The arguments above are provided in a similar format to
<code>t.test()</code>. It also appears that homoscedasticity does not
hold: since the p-value is less than 0.05, we should reject the null
hypothesis that variances between the manager and IC dataset are
equal.</p>
<p>Homoscedasticity can also be examined visually, via a boxplot or a
dotplot (using <code>graphics::dotchart()</code> - suitable for small
datasets). The code to do so would be as follows. For this example,
visual examination is a bit more challenging as the senior IC and
Manager groups have starkly different levels of multi-tasking hours.</p>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true" tabindex="-1"></a><span class="fu">dotchart</span>(</span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true" tabindex="-1"></a>  <span class="at">x =</span> pq_data_grouped<span class="sc">$</span>Multitasking_hours,</span>
<span id="cb15-3"><a href="#cb15-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">groups =</span> pq_data_grouped<span class="sc">$</span>ManagerIndicator</span>
<span id="cb15-4"><a href="#cb15-4" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/figure-html/unnamed-chunk-10-1.png" /><!-- --></p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb16-1"><a href="#cb16-1" aria-hidden="true" tabindex="-1"></a><span class="fu">boxplot</span>(</span>
<span id="cb16-2"><a href="#cb16-2" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb16-3"><a href="#cb16-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped</span>
<span id="cb16-4"><a href="#cb16-4" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/association_of_variables_20221007_files/figure-html/unnamed-chunk-10-2.png" /><!-- --></p>
</div>
</div>
<div id="non-parametric-tests" class="section level2">
<h2>Non-parametric tests</h2>
<p>Previously, we could not safely rely on the unpaired two-sample
t-test because the data does not satisfy the normality condition. As an
alternative, we can use the <strong>Wilcoxon Rank-Sum test</strong> (aka
Mann Whitney U Test). The difference between the Wilcoxon Rank-Sum test
and the unpaired t-test is that the former tests whether two populations
have the same shape via comparing medians, whereas the latter parametric
test compares means between two independent groups.</p>
<p>The Wilcoxon test is described as a <strong>non-parametric
test</strong>, which in statistics typically means that there is no
specification on a distribution, or the parameters of a distribution; in
this case, the test does not assume a normal distribution.</p>
<p>This is run using <code>wilcox.test()</code></p>
<div class="sourceCode" id="cb17"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb17-1"><a href="#cb17-1" aria-hidden="true" tabindex="-1"></a><span class="fu">wilcox.test</span>(</span>
<span id="cb17-2"><a href="#cb17-2" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb17-3"><a href="#cb17-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped,</span>
<span id="cb17-4"><a href="#cb17-4" aria-hidden="true" tabindex="-1"></a>  <span class="at">paired =</span> <span class="cn">FALSE</span></span>
<span id="cb17-5"><a href="#cb17-5" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<pre><code>## 
##  Wilcoxon rank sum exact test
## 
## data:  Multitasking_hours by ManagerIndicator
## W = 752, p-value = 2.842e-14
## alternative hypothesis: true location shift is not equal to 0</code></pre>
<p>The p-value of the test is less than the significance level (alpha =
0.05), which allows us to conclude that Manager’s median multitasking
hours is significantly different from the IC’s.</p>
<p>Note that the Wilcoxon Rank-Sum test is different from the similarly
named Wilcoxon Signed-Rank test, which is the equivalent alternative for
the <em>paired</em> t-test. To perform the Wilcoxon Signed-Rank test
instead, you can simply specify the argument to be
<code>paired = TRUE</code>. Similar to the decision of whether to use
the paired or the unpaired t-test, you should ensure that the one-sample
condition applies if you use the Wilcoxon Signed-Rank test.</p>
<p>So far, we have only been looking at tests which compare exactly two
populations. If we are looking for a test that works with comparisons
across three or more populations, we can consider the
<strong>Kruskal-Wallis test</strong>.</p>
<p>Let us create a new data frame that is grouped at the
<code>PersonId</code> level, but filtering out fewer values in
<code>LevelDesignation</code>:</p>
<div class="sourceCode" id="cb19"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb19-1"><a href="#cb19-1" aria-hidden="true" tabindex="-1"></a>pq_data_grouped_2 <span class="ot">&lt;-</span></span>
<span id="cb19-2"><a href="#cb19-2" aria-hidden="true" tabindex="-1"></a>  pq_data <span class="sc">%&gt;%</span></span>
<span id="cb19-3"><a href="#cb19-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(LevelDesignation <span class="sc">%in%</span> <span class="fu">c</span>(</span>
<span id="cb19-4"><a href="#cb19-4" aria-hidden="true" tabindex="-1"></a>    <span class="st">&quot;Support&quot;</span>,</span>
<span id="cb19-5"><a href="#cb19-5" aria-hidden="true" tabindex="-1"></a>    <span class="st">&quot;Senior IC&quot;</span>,</span>
<span id="cb19-6"><a href="#cb19-6" aria-hidden="true" tabindex="-1"></a>    <span class="st">&quot;Junior IC&quot;</span>,</span>
<span id="cb19-7"><a href="#cb19-7" aria-hidden="true" tabindex="-1"></a>    <span class="st">&quot;Manager&quot;</span>,</span>
<span id="cb19-8"><a href="#cb19-8" aria-hidden="true" tabindex="-1"></a>    <span class="st">&quot;Director&quot;</span></span>
<span id="cb19-9"><a href="#cb19-9" aria-hidden="true" tabindex="-1"></a>  )) <span class="sc">%&gt;%</span></span>
<span id="cb19-10"><a href="#cb19-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(<span class="at">ManagerIndicator =</span> <span class="fu">factor</span>(LevelDesignation)) <span class="sc">%&gt;%</span></span>
<span id="cb19-11"><a href="#cb19-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">group_by</span>(PersonId, ManagerIndicator) <span class="sc">%&gt;%</span></span>
<span id="cb19-12"><a href="#cb19-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">summarise</span>(<span class="at">Multitasking_hours =</span> <span class="fu">mean</span>(Multitasking_hours), <span class="at">.groups =</span> <span class="st">&quot;drop&quot;</span>)</span>
<span id="cb19-13"><a href="#cb19-13" aria-hidden="true" tabindex="-1"></a>  </span>
<span id="cb19-14"><a href="#cb19-14" aria-hidden="true" tabindex="-1"></a><span class="fu">glimpse</span>(pq_data_grouped_2)</span></code></pre></div>
<pre><code>## Rows: 198
## Columns: 3
## $ PersonId           &lt;chr&gt; &quot;0049ef24-ec83-356d-89f7-46b67364e677&quot;, &quot;00f6d464-b~
## $ ManagerIndicator   &lt;fct&gt; Support, Senior IC, Manager, Support, Support, Supp~
## $ Multitasking_hours &lt;dbl&gt; 0.3812649, 0.2813373, 0.5980080, 0.2918829, 0.42288~</code></pre>
<p>We can then run the Kruskal-Wallis test:</p>
<div class="sourceCode" id="cb21"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb21-1"><a href="#cb21-1" aria-hidden="true" tabindex="-1"></a><span class="fu">kruskal.test</span>(</span>
<span id="cb21-2"><a href="#cb21-2" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb21-3"><a href="#cb21-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped_2</span>
<span id="cb21-4"><a href="#cb21-4" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<pre><code>## 
##  Kruskal-Wallis rank sum test
## 
## data:  Multitasking_hours by ManagerIndicator
## Kruskal-Wallis chi-squared = 91.061, df = 4, p-value &lt; 2.2e-16</code></pre>
<p>Based on the Kruskal-Wallis test, we reject the null hypothesis and
we conclude that at least one value in <code>LevelDesignation</code> is
different in terms of their weekly hours spent multitasking. The most
obvious downside to this method is that it does not tell us which groups
are different from which, so this may need to be followed up with
multiple pairwise-comparison tests.</p>
</div>
<div id="anova---comparing-across-multiple-groups"
class="section level2">
<h2>ANOVA - comparing across multiple groups</h2>
<p>Analysis of Variance (ANOVA) generalises the t-test beyond 2 groups,
so it is used to compare 3 or more groups.</p>
<p>There are several versions of ANOVA. The simple version is the
one-way ANOVA, but there is also two-way ANOVA which is used to estimate
how the mean of a quantitative variable changes according to the levels
of two categorical variables (e.g. rain/no-rain and weekend/weekday to
predict ice cream sales). For this example, we will focus on one-way
ANOVA.</p>
<p>There are three assumptions in ANOVA: - The responses for each factor
level have a normal population distribution. - These distributions have
the same variance. - The data are independent.</p>
<p>These assumptions are similar to the ones required for the t-test,
and you can run the same tests for variance and normality prior to
ANOVA.</p>
<p>ANOVA compares the ratio of the between-group variance and the
within-group variance, and then compares this with a threshold from the
Fisher distribution (typically based on a significance level).</p>
<p>The p-value is found using the f-statistic and the
f-distribution.</p>
</div>
<div id="correlations" class="section level2">
<h2>Correlations</h2>
<p>Correlation tests are used in statistics to measure how strong a
relationship is between two variables, without hypothesising any causal
effect between the variables. There are several types of correlation
coefficients (e.g. Pearson’s <em>r</em>, Kendall’s <em>tau</em>,
Spearman’s <em>rho</em>), but the most commonly used is the Pearson’s
correlation coefficient.</p>
<p>Correlation tests are a form of <strong>non-parametric test</strong>,
which don’t make as many assumptions about the data and are useful when
one or more of the common statistical assumptions are violated. However,
the inferences they make aren’t as strong as with parametric tests.</p>
<p>Correlation is a way to test if two variables have any kind of
relationship, whereas p-value tells us if the result of an experiment is
statistically significant.</p>
<p>The statistical significance of a correlation can be evaluated with
the t-statistic. This can be yielded with <code>cor.test()</code> in
R:</p>
<div class="sourceCode" id="cb23"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb23-1"><a href="#cb23-1" aria-hidden="true" tabindex="-1"></a><span class="fu">cor.test</span>()</span></code></pre></div>
<p>This output provides the correlation coefficient, the t-statistic,
df, p-value, and the 95% confidence interval for the correlation
coefficient. The two variables you supply to the function should both be
continuous (most likely type <code>numeric</code>, <code>integer</code>,
or <code>double</code> in R).</p>
<p>Note that the t statistic for the correlation depends on the
magnitude of the correlation coefficient (r) and the <strong>sample
size</strong>. With a large sample, even weak correlations can become
statistically significant.</p>
<div id="relationship-with-simple-linear-regression"
class="section level3">
<h3>Relationship with simple linear regression</h3>
<p>One might also be led to believe that the correlation coefficient is
similar to the slope of a simple linear regression. For one, the test
for correlation will more or less lead to a similar conclusion as the
test for slope. The sign of the slope (+/-ve) will be the same for
correlation, and both values should indicate the direction of the
relationship.</p>
<p>However, those two statistics are different: the correlation
coefficient only tells you how closely your data fit on a line, so two
datasets with the same correlation coefficient can have very different
slopes. In other words, the value of the correlation indicates the
<em>strength</em> of the linear relationship. The value of the slope
does not. Moreover, the slope interpretation tells you the change in the
response for a one-unit increase in the predictor. Correlation does not
have this kind of interpretation.</p>
</div>
<div id="pitfalls" class="section level3">
<h3>Pitfalls?</h3>
<p>Outliers and non-linear relationships.</p>
<p>A simple way to evaluate whether a relationship is reasonably linear
is to examine a scatter plot.</p>
<p>P-value evaluates how well your data rejects the <strong>null
hypothesis</strong>, which states that there is no relationship between
two compared groups.</p>
<p>p-value is the probability of obtaining results as extreme or more
extreme, given the null hypothesis is true.</p>
</div>
</div>
<div id="effect-size" class="section level2">
<h2>Effect size</h2>
</div>
<div id="statistical-power" class="section level2">
<h2>Statistical power</h2>
<p><strong>Statistical power</strong> is the probability of identifying
an interaction effect on a dependent variable with the specified sample
characteristics. The most common use of power calculations is to
estimate how big a sample you will need.</p>
</div>
<div id="sample-variance" class="section level2">
<h2>Sample variance</h2>
<p>Examining in-sample variation and between-sample variation are both
helpful when comparing means across two populations.</p>
<p>The f-statistic is in fact calculated by the between-group variance
divided by the within-group variance.</p>
<p>This is where <strong>ANOVA</strong> (Analysis of Variance) comes
into play here, where ANOVA is a statistical test used to analyze the
difference between the means of more than two groups.</p>
</div>
<div id="references" class="section level2">
<h2>References</h2>
<ul>
<li><a
href="https://sphweb.bumc.bu.edu/otlt/MPH-Modules/PH717-QuantCore/PH717-Module9-Correlation-Regression/index.html">Correlation
and Regression</a></li>
<li><a
href="https://online.stat.psu.edu/stat500/lesson/9/9.4/9.4.2">PennState
STAT500</a></li>
<li><a
href="https://www.scribbr.com/statistics/statistical-tests/">Guide on
when to use which statistical tests and when</a></li>
<li><a
href="http://www.sthda.com/english/wiki/unpaired-two-samples-t-test-in-r/">Unpaired
t-tests in R</a></li>
<li><a href="https://statsandr.com/blog/anova-in-r/">ANOVA in R</a></li>
<li><a
href="https://statsandr.com/blog/kruskal-wallis-test-nonparametric-version-anova/">Kruskall-Wallis
Test in R</a></li>
</ul>
</div>
</div>
<div class="footnotes footnotes-end-of-document">
<hr />
<ol>
<li id="fn1"><p>See <a
href="https://learn.microsoft.com/en-us/viva/insights/use/metric-definitions"
class="uri">https://learn.microsoft.com/en-us/viva/insights/use/metric-definitions</a>
for definitions.<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
