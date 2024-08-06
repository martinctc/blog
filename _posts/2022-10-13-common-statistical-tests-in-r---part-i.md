---
title: "Common Statistical Tests in R - Part I"

author: "Martin Chan"
date: "October 13, 2022"
layout: post
tags: statistics vignettes r
image: https://raw.githubusercontent.com/martinctc/blog/master/images/breaking-bad-heisenberg.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/header-attrs-2.16/header-attrs.js"></script>

<section class="main-content">
<div id="introduction" class="section level1">
<h1>Introduction</h1>
<p>This post will focus on common statistical tests in R to understand
and validate the relationship between two variables.</p>
<p>There must be tons of similar tutorials around, you may be thinking.
So why?</p>
<p>The primary (and selfish) goal of the post is to create a guide that
is practical enough for myself to refer to from time to time. This post
is edited from my own notes from learning statistics and R, and have
been applied to a data example/scenario that I am familiar with. This
means that the examples should be easily generalisable and mostly
consistent with my usual coding approach (mostly ‘tidy’ and using
pipes). Along the way, this will hopefully benefit others who are
learning statistics and R too.</p>
<div class="figure">
<img
src="https://raw.githubusercontent.com/martinctc/blog/master/images/breaking-bad-heisenberg.gif"
alt="" />
<p class="caption">image from Giphy</p>
</div>
<p>To illustrate the R code, I will be using a sample dataset
<code>pq_data</code> from the package <a
href="https://microsoft.github.io/vivainsights/"><strong>vivainsights</strong></a>,
which is a cross-sectional time-series dataset measuring the
collaboration behaviour of simulated employees in an organization. Each
row represents an employee on a certain week, with columns measuring
behaviours such as total weekly time spent in email, meetings, chats,
and so on. The <strong>vivainsights</strong> package itself provides
visualisation and analysis functions tailored for these datasets which
are available from <a
href="https://www.microsoft.com/en-us/microsoft-viva/insights/">Microsoft
Viva Insights</a>.</p>
<p>A note about the structure of this post: in the real world, one
should as a best practice visually check the data distribution and run
tests for assumptions like normality prior to performing any tests. For
the sake of narrative and covering all the scenarios, this practice
isn’t really observed in this post. Hence, please be forgiving as you
see us run ‘head first’ into a test without examining the data - and
avoid this in real life!</p>
</div>
<div id="set-up-packages-and-data" class="section level1">
<h1>Set-up: packages and data</h1>
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
<div id="framing-the-problem" class="section level1">
<h1>Framing the problem</h1>
<p>One of the most fundamental tasks in statistics and data science is
to understand the relation between two variables. Sometimes the
motivation is understand whether the relationship is causal,
i.e. whether one causes another. This is not always the case, as for
instance, one may simply wish to test for
<strong>multicollinearity</strong> when selecting predictors for a
model.<a href="#fn1" class="footnote-ref"
id="fnref1"><sup>1</sup></a></p>
<p>Our dataset <code>pq_data</code> represents the simulated
collaboration data of a company, and each row represents an employee’s
week. There are two metrics of interest:</p>
<ul>
<li><code>Multitasking_hours</code> measures the total number of hours
the person spent sending emails or instant messages during a meeting or
a Teams call.</li>
<li><code>After_hours_collaboration_hours</code> measures the number of
hours a person has spent in collaboration (meetings, emails, IMs, and
calls) outside of working hours.<a href="#fn2" class="footnote-ref"
id="fnref2"><sup>2</sup></a></li>
</ul>
<p>Imagine then we have two questions to address:</p>
<ol style="list-style-type: decimal">
<li><p>Do <em>managers</em> multi-task more than <em>senior individual
contributors (IC)</em>?</p></li>
<li><p>The HR leadership suspects that meeting multitasking behaviour
could be correlated with after-hours working, as the former represents
wasted time and productivity during meetings. What can we do to
understand the relationship between the two?</p></li>
</ol>
<p>In this post, we will tackle the first question, and focus primarily
on <strong>comparison tests</strong> and their non-parametric
equivalents in R. In subsequent posts I would also like to cover other
relevant tools/concepts such as correlation tests, regression tests,
effect size, and statistical power.</p>
<p>It is worth noting that the first question postulates a relation
between a <strong>categorical</strong> variable (manager/ senior IC) and
a <strong>continuous</strong> variable (multitasking hours), whereas the
second question a relation between two <strong>continuous</strong>
variables (multitasking hours, afterhours collaboration). The types of
the variables in question help determine which tests are
appropriate.</p>
<p>The categorical variable that provides us information on whether an
employee is a manager or a senior IC in <code>pq_data</code> is stored
in <code>LevelDesignation</code>. We can use
<code>vivainsights::hrvar_count()</code> to explore this variable:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="fu">hrvar_count</span>(pq_data, <span class="at">hrvar =</span> <span class="st">&quot;LevelDesignation&quot;</span>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/figure-html/unnamed-chunk-3-1.png" /><!-- --></p>
</div>
<div id="comparison-tests-the-t-test" class="section level1">
<h1>1. Comparison tests: the t-test</h1>
<p>Two common comparison tests would be the <strong>t-test</strong> and
<strong>Analysis of Variance (ANOVA)</strong>. The oft-cited
<em>practical</em> difference between the two is that you would use the
t-test for comparing means between two groups, and ANOVA for more than
two groups. There is a bit more nuance than that, but we will start with
the t-test.</p>
<p>A t-test can be <em>paired</em> or <em>unpaired</em>, where the
former is used for comparing the means of two groups in the <em>same
population</em>, and the latter for <em>independent samples from two
populations or groups</em>. Since managers and senior ICs are two
different populations, an unpaired (two-sample) t-test is therefore
appropriate for the scenario in question two.</p>
<p>Before we jump into the test, we’ll need to prepare the data. Since
we are interested in the difference between managers and senior ICs, we
will first need to create a factor variable from the data that has only
two levels. In the below code, we will first filter out any values of
<code>LevelDesignation</code> that are not <code>"Manager"</code> and
<code>"Senior IC"</code>, and create a new factor column as
<code>ManagerIndicator</code>:</p>
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
rows representing a snapshot of a different week. In other words, a
unique identifier would be something like a <code>PersonWeekId</code>.
To simplify the dataset so that we are looking at person averages, we
can group the dataset by <code>PersonId</code> and calculate the mean of
<code>Multitasking_hours</code> for each person. After this
manipulation, <code>Multitasking_hours</code> would represent the mean
multitasking hours <em>per person</em>, as opposed to <em>per person per
week</em>. Let us do this by building on the pipe-chain:</p>
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
<p>Now our data is in the right format.</p>
<p>Let us presume that the data satisfies all the assumptions of the
t-test, and see what happens when we run it with the base
<code>t.test()</code> function:</p>
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
t-test</strong>. The Welch’s t-test compares the variances of the two
groups (i.e. handling heteroscedasticity), whereas the classic Student’s
t-test assumes the variances of the two groups to be equal (fancy term =
homoscedastic).</p>
<div id="testing-for-normality" class="section level2">
<h2>1.1 Testing for normality</h2>
<p>But hang on!</p>
<p>There are several assumptions behind the classic t-test we haven’t
examined properly, namely:</p>
<ol style="list-style-type: decimal">
<li>independence - sample is independent</li>
<li>normality - data for each group is normally distributed</li>
<li>homoscedasticity - data across samples have equal variance</li>
</ol>
<p>We can at least be sure of (1), as we know that senior ICs and
Managers are separate populations. However, (2) and (3) are assumptions
that we have to validate and address specifically. To test whether our
data is normally distributed, we can use the <strong>Shapiro-Wilk test
of normality</strong>, with the function
<code>shapiro.test()</code>:</p>
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
src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/figure-html/unnamed-chunk-8-1.png" /><!-- --></p>
<div class="sourceCode" id="cb12"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb12-1"><a href="#cb12-1" aria-hidden="true" tabindex="-1"></a><span class="co"># Multitasking hours - Manager</span></span>
<span id="cb12-2"><a href="#cb12-2" aria-hidden="true" tabindex="-1"></a>mth_man <span class="ot">&lt;-</span></span>
<span id="cb12-3"><a href="#cb12-3" aria-hidden="true" tabindex="-1"></a>  pq_data_grouped <span class="sc">%&gt;%</span></span>
<span id="cb12-4"><a href="#cb12-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(ManagerIndicator <span class="sc">==</span> <span class="st">&quot;Manager&quot;</span>) <span class="sc">%&gt;%</span></span>
<span id="cb12-5"><a href="#cb12-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">pull</span>(Multitasking_hours) </span>
<span id="cb12-6"><a href="#cb12-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb12-7"><a href="#cb12-7" aria-hidden="true" tabindex="-1"></a><span class="fu">qqnorm</span>(mth_man, <span class="at">pch =</span> <span class="dv">1</span>, <span class="at">frame =</span> <span class="cn">FALSE</span>)</span>
<span id="cb12-8"><a href="#cb12-8" aria-hidden="true" tabindex="-1"></a><span class="fu">qqline</span>(mth_man, <span class="at">col =</span> <span class="st">&quot;steelblue&quot;</span>, <span class="at">lwd =</span> <span class="dv">2</span>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/figure-html/unnamed-chunk-8-2.png" /><!-- --></p>
<p>In the Q-Q plots, the points broadly adhere to the reference line.
Therefore, the graphical approach suggests that the Shapiro-Wilk test
may have been slightly over-sensitive. Below is a good thing to bear in
mind:<a href="#fn3" class="footnote-ref"
id="fnref3"><sup>3</sup></a></p>
<blockquote>
<p>Statistical tests have the advantage of making an objective judgment
of normality but have the disadvantage of sometimes not being sensitive
enough at low sample sizes or overly sensitive to large sample sizes.
Graphical interpretation has the advantage of allowing good judgment to
assess normality in situations when numerical tests might be over or
undersensitive.</p>
</blockquote>
<p>In other words, the sample sizes may have well played a role in the
significant result in our Shapiro-Wilk test.<a href="#fn4"
class="footnote-ref" id="fnref4"><sup>4</sup></a> As our data isn’t
conclusively normal - this in turn makes the unpaired t-test less
conclusive. When we cannot safely assume normality, we can consider
other alternatives such as the <strong>non-parametric two-samples
Wilcoxon Rank-Sum test</strong>. This is covered further down below.</p>
</div>
<div id="testing-for-equality-of-variance-homoscedasticity"
class="section level2">
<h2>1.2 Testing for equality of variance (homoscedasticity)</h2>
<p>Asides from normality, another assumption of the t-test that we
hadn’t properly test for prior to running <code>t.test()</code> is to
check for equality of variance across the two groups (homoscedasticity).
Thankfully, this was not something we had to worry about as we used the
Welch’s t-test. Recall that the classic Student’s t-test assumes
equality between the two variances, but the Welch’s t-test already takes
the difference in variance into account.</p>
<p>If required, however, here is an example on how you can test for
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
<p>The <code>var.test()</code> function ran above is an F-test
(i.e. uses the F-distribution) used to compare whether the variances of
two samples are the same. Under the null hypothesis of the tests, there
should be homoscedasticity and as the f-statistic is a ratio of
variances, the f-statistic would tend towards 1. The arguments are
provided in a similar format to <code>t.test()</code>.</p>
<p>It appears that homoscedasticity does not hold: since the p-value is
less than 0.05, we should reject the null hypothesis that variances
between the manager and IC dataset are equal. The Student’s t-test would
not have been appropriate here, and we were correct to have used the
Welch’s t-test.</p>
<p>Homoscedasticity can also be examined visually, using a boxplot or a
dotplot (using <code>graphics::dotchart()</code> - suitable for small
datasets). The code to do so would be as follows. For this example,
visual examination is a bit more challenging as the senior IC and
Manager groups have starkly different levels of multi-tasking hours.</p>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true" tabindex="-1"></a><span class="fu">dotchart</span>(</span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true" tabindex="-1"></a>  <span class="at">x =</span> pq_data_grouped<span class="sc">$</span>Multitasking_hours,</span>
<span id="cb15-3"><a href="#cb15-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">groups =</span> pq_data_grouped<span class="sc">$</span>ManagerIndicator</span>
<span id="cb15-4"><a href="#cb15-4" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/figure-html/unnamed-chunk-10-1.png" /><!-- --></p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb16-1"><a href="#cb16-1" aria-hidden="true" tabindex="-1"></a><span class="fu">boxplot</span>(</span>
<span id="cb16-2"><a href="#cb16-2" aria-hidden="true" tabindex="-1"></a>  Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb16-3"><a href="#cb16-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">data =</span> pq_data_grouped</span>
<span id="cb16-4"><a href="#cb16-4" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<p><img
src="{{ site.url }}{{ site.baseurl }}/knitr_files/common-statistical-tests_20221007_files/figure-html/unnamed-chunk-10-2.png" /><!-- --></p>
</div>
</div>
<div id="non-parametric-tests" class="section level1">
<h1>2. Non-parametric tests</h1>
<div id="wilcoxon-rank-sum-test" class="section level2">
<h2>2.1 Wilcoxon Rank-Sum Test</h2>
<p>Previously, we could not safely rely on the unpaired two-sample
t-test because we are not fully confident that the data satisfies the
normality condition. As an alternative, we can use the <strong>Wilcoxon
Rank-Sum test</strong> (aka Mann Whitney U Test). The Wilcoxon test is
described as a <strong>non-parametric test</strong>, which in statistics
typically means that there is no specification on a distribution, or the
parameters of a distribution. In this case, the Wilcoxon test does not
assume a normal distribution.</p>
<p>Another difference between the Wilcoxon Rank-Sum test and the
unpaired t-test is that the former tests whether two populations have
the same shape via comparing medians, whereas the latter parametric test
compares means between two independent groups.</p>
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
0.05), which allows us to conclude that Managers’ median multitasking
hours is significantly different from the ICs’.</p>
<p>Note that the Wilcoxon Rank-Sum test is different from the similarly
named Wilcoxon Signed-Rank test, which is the equivalent alternative for
the <em>paired</em> t-test. To perform the Wilcoxon Signed-Rank test
instead, you can simply specify the argument to be
<code>paired = TRUE</code>. Similar to the decision of whether to use
the paired or the unpaired t-test, you should ensure that the one-sample
condition applies if you use the Wilcoxon Signed-Rank test.</p>
</div>
<div id="kruskal-wallis-test" class="section level2">
<h2>2.2 Kruskal-Wallis test</h2>
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
multiple pairwise-comparison tests (also known as <em>post-hoc
tests</em>).</p>
</div>
</div>
<div id="comparison-tests-anova" class="section level1">
<h1>3. Comparison tests: ANOVA</h1>
<div id="anova" class="section level2">
<h2>3.1 ANOVA</h2>
<p>What if we want to run the t-test across more than two groups?</p>
<p><strong>Analysis of Variance (ANOVA)</strong> is an alternative
method that generalises the t-test beyond two groups, so it is used to
compare three or more groups.</p>
<p>There are several versions of ANOVA. The simple version is the
<em>one-way ANOVA</em>, but there is also <em>two-way ANOVA</em> which
is used to estimate how the mean of a quantitative variable changes
according to the levels of two categorical variables (e.g. rain/no-rain
and weekend/weekday with respect to ice cream sales). In this example we
will focus on one-way ANOVA.</p>
<p>There are three assumptions in ANOVA, and this may look familiar:</p>
<ul>
<li>The data are independent.</li>
<li>The responses for each factor level have a normal population
distribution.</li>
<li>These distributions have the same variance.</li>
</ul>
<p>These assumptions are the same as those required for the classic
t-test above, and it is recommended that you check for variance and
normality prior to ANOVA.</p>
<p>ANOVA calculates the ratio of the <strong>between-group
variance</strong> and the <strong>within-group variance</strong>
(quantified using sum of squares), and then compares this with a
threshold from the Fisher distribution (typically based on a
significance level). The key function is <code>aov()</code>:</p>
<div class="sourceCode" id="cb23"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb23-1"><a href="#cb23-1" aria-hidden="true" tabindex="-1"></a>res_aov <span class="ot">&lt;-</span></span>
<span id="cb23-2"><a href="#cb23-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aov</span>(</span>
<span id="cb23-3"><a href="#cb23-3" aria-hidden="true" tabindex="-1"></a>    Multitasking_hours <span class="sc">~</span> ManagerIndicator,</span>
<span id="cb23-4"><a href="#cb23-4" aria-hidden="true" tabindex="-1"></a>    <span class="at">data =</span> pq_data_grouped_2</span>
<span id="cb23-5"><a href="#cb23-5" aria-hidden="true" tabindex="-1"></a>  )</span>
<span id="cb23-6"><a href="#cb23-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb23-7"><a href="#cb23-7" aria-hidden="true" tabindex="-1"></a><span class="fu">summary</span>(res_aov)</span></code></pre></div>
<pre><code>##                   Df Sum Sq Mean Sq F value Pr(&gt;F)    
## ManagerIndicator   4  40.55   10.14   504.6 &lt;2e-16 ***
## Residuals        193   3.88    0.02                   
## ---
## Signif. codes:  0 &#39;***&#39; 0.001 &#39;**&#39; 0.01 &#39;*&#39; 0.05 &#39;.&#39; 0.1 &#39; &#39; 1</code></pre>
<p>The interpretation is as follows:<a href="#fn5" class="footnote-ref"
id="fnref5"><sup>5</sup></a></p>
<ul>
<li><p><code>Df</code>: degrees of freedom for…</p>
<ul>
<li>the outcome variable, i.e. the number of levels in the variable
minus 1</li>
<li>the residuals, i.e. the total number of observations minus one and
minus the number of levels in the outcome variables</li>
</ul></li>
<li><p><code>Sum Sq</code>: sum of squares, i.e. the total variation
between the group means and the overall mean</p></li>
<li><p><code>Mean Sq</code>: mean of the sum of squares, calculated by
dividing the sum of squares by the degrees of freedom for each
parameter</p></li>
<li><p><code>F value</code>: test statistic from the F test. This is the
mean square of each independent variable divided by the mean square of
the residuals. The larger the F value, the more likely it is that the
variation caused by the outcome variable is real and not due to
chance.</p></li>
<li><p><code>Pr(&gt;F)</code>: p-value of the F-statistic. This shows
how likely it is that the F-value calculated from the test would have
occurred if the null hypothesis of no difference among group means were
true.</p></li>
</ul>
<p>Given that the p-value is smaller than 0.05, we reject the null
hypothesis, so we reject the hypothesis that all means are equal.
Therefore, we can conclude that at least one value in
<code>LevelDesignation</code> is different in terms of their weekly
hours spent multitasking.</p>
<p><a href="https://statsandr.com/blog/anova-in-r/">Antoine Soetewey’s
blog</a> recommends the use of the <strong>report</strong> package,
which can help you make sense of the results more easily:</p>
<div class="sourceCode" id="cb25"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb25-1"><a href="#cb25-1" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(report)</span>
<span id="cb25-2"><a href="#cb25-2" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb25-3"><a href="#cb25-3" aria-hidden="true" tabindex="-1"></a><span class="fu">report</span>(res_aov)</span></code></pre></div>
<pre><code>## The ANOVA (formula: Multitasking_hours ~ ManagerIndicator) suggests that:
## 
##   - The main effect of ManagerIndicator is statistically significant and large
## (F(4, 193) = 504.61, p &lt; .001; Eta2 = 0.91, 95% CI [0.90, 1.00])
## 
## Effect sizes were labelled following Field&#39;s (2013) recommendations.</code></pre>
<p>The same drawback that applies to the Kruskall-Wallis test also
applies to ANOVA, in that doesn’t actually tell you which exact group is
different from which; it only tells you whether any group differs
significantly from the group mean. This ANOVA test is hence sometimes
also referred to as an ‘omnibus’ test.</p>
</div>
<div id="next-steps-after-anova" class="section level2">
<h2>3.2 Next steps after ANOVA</h2>
<p>A <em>pairwise</em> t-test (note: <em>pairwise</em>, not
<em>paired</em>!) is likely required to provide more information, and it
is recommended that you review the <a
href="https://rdrr.io/r/stats/p.adjust.html">p-value adjustment
methods</a> when doing so.<a href="#fn6" class="footnote-ref"
id="fnref6"><sup>6</sup></a> Type I errors are more likely when running
t-tests pairwise across many variables, and therefore correction is
necessary. Here is an example of how you might run a pairwise
t-test:</p>
<div class="sourceCode" id="cb27"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb27-1"><a href="#cb27-1" aria-hidden="true" tabindex="-1"></a><span class="fu">pairwise.t.test</span>(</span>
<span id="cb27-2"><a href="#cb27-2" aria-hidden="true" tabindex="-1"></a>  <span class="at">x =</span> pq_data_grouped_2<span class="sc">$</span>Multitasking_hours,</span>
<span id="cb27-3"><a href="#cb27-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">g =</span> pq_data_grouped_2<span class="sc">$</span>ManagerIndicator,</span>
<span id="cb27-4"><a href="#cb27-4" aria-hidden="true" tabindex="-1"></a>  <span class="at">paired =</span> <span class="cn">FALSE</span>,</span>
<span id="cb27-5"><a href="#cb27-5" aria-hidden="true" tabindex="-1"></a>  <span class="at">p.adjust.method =</span> <span class="st">&quot;bonferroni&quot;</span></span>
<span id="cb27-6"><a href="#cb27-6" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<pre><code>## 
##  Pairwise comparisons using t tests with pooled SD 
## 
## data:  pq_data_grouped_2$Multitasking_hours and pq_data_grouped_2$ManagerIndicator 
## 
##           Director Junior IC Manager Senior IC
## Junior IC &lt;2e-16   -         -       -        
## Manager   &lt;2e-16   &lt;2e-16    -       -        
## Senior IC &lt;2e-16   1         &lt;2e-16  -        
## Support   &lt;2e-16   1         &lt;2e-16  1        
## 
## P value adjustment method: bonferroni</code></pre>
<p>It may not be surprising that a pairwise method also exists as a
follow-up for the Kruskall-Wallis test - which is the pairwise Wilcoxon
test! This can be run using <code>pairwise.wilcox.test()</code>. The API
for the <code>pairwise.wilcox.test()</code> is very similar to
<code>pairwise.t.test()</code> where you can change the p-value
adjustment method using the argument <code>p.adjust.method</code>:</p>
<div class="sourceCode" id="cb29"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb29-1"><a href="#cb29-1" aria-hidden="true" tabindex="-1"></a><span class="fu">pairwise.wilcox.test</span>(</span>
<span id="cb29-2"><a href="#cb29-2" aria-hidden="true" tabindex="-1"></a>  <span class="at">x =</span> pq_data_grouped_2<span class="sc">$</span>Multitasking_hours,</span>
<span id="cb29-3"><a href="#cb29-3" aria-hidden="true" tabindex="-1"></a>  <span class="at">g =</span> pq_data_grouped_2<span class="sc">$</span>ManagerIndicator,</span>
<span id="cb29-4"><a href="#cb29-4" aria-hidden="true" tabindex="-1"></a>  <span class="at">paired =</span> <span class="cn">FALSE</span>,</span>
<span id="cb29-5"><a href="#cb29-5" aria-hidden="true" tabindex="-1"></a>  <span class="at">p.adjust.method =</span> <span class="st">&quot;bonferroni&quot;</span></span>
<span id="cb29-6"><a href="#cb29-6" aria-hidden="true" tabindex="-1"></a>)</span></code></pre></div>
<pre><code>## 
##  Pairwise comparisons using Wilcoxon rank sum exact test 
## 
## data:  pq_data_grouped_2$Multitasking_hours and pq_data_grouped_2$ManagerIndicator 
## 
##           Director Junior IC Manager Senior IC
## Junior IC 5.3e-09  -         -       -        
## Manager   3.3e-09  1.3e-09   -       -        
## Senior IC 5.9e-11  1         2.8e-13 -        
## Support   1.3e-08  1         8.6e-13 1        
## 
## P value adjustment method: bonferroni</code></pre>
</div>
</div>
<div id="summary" class="section level1">
<h1>4. Summary</h1>
<p>So far, the following tests we performed have yielded similar
results:</p>
<ol style="list-style-type: decimal">
<li><em>For comparing Senior ICs and Managers:</em>
<ul>
<li>unpaired two-sample t-test (assumes normality)</li>
<li>Wilcoxon Rank-Sum test (non-parametric)</li>
</ul></li>
<li><em>For comparing across more than two values:</em>
<ul>
<li>ANOVA (assumes normality)</li>
<li>Kruskal-Wallis test (non-parametric)</li>
</ul></li>
<li><em>For following up on (2) with pairwise comparisons:</em>
<ul>
<li>pairwise t-test with correction (assumes normality)</li>
<li>pairwise Wilcoxon test (non-parametric)</li>
</ul></li>
</ol>
<p>To the first business question, we can conclude that Senior ICs have
significantly lower multitasking hours than Managers. Although the data
for the two groups are not normal or equal in variance, the mitigating
solutions we used have also found the differences to be significant.
Moreover, it appears that significant differences also exist across
other levels when we reviewed the post-hoc tests.</p>
<div
id="should-i-use-a-t-test-or-anova-for-comparing-exactly-two-groups"
class="section level2">
<h2>4.1 Should I use a t-test or ANOVA for comparing exactly two
groups?</h2>
<p>One question worth discussing is the scenario at (1). Suppose that
normality is observed in both groups, does it make a difference whether
I use the t-test or ANOVA if I am comparing exactly two groups?</p>
<p>The textbook recommendation is that whenever one is comparing exactly
two groups one should use the t-test, and ANOVA whenever there are more
than two groups being compared. What can get confusing here is that
there is the classic Student’s t-test and the Welch’s t-test.</p>
<p>When ANOVA is used to compare two groups, the results will be
equivalent to a classic (Student’s) t-test with equal variances.<a
href="#fn7" class="footnote-ref" id="fnref7"><sup>7</sup></a> However,
if we are talking about the Welch’s t-test instead, it may be preferable
over ANOVA because the Welch’s t-test takes into account
heteroscedasticity. When there is heteroscedasticity, ANOVA (as well as
Kruskall-Wallis) would become unstable and produce Type I errors, such
as:</p>
<ul>
<li>conservative estimates for large sample sizes</li>
<li>inflated estimates for small sample size<a href="#fn8"
class="footnote-ref" id="fnref8"><sup>8</sup></a></li>
</ul>
<p>To further complicate matters, there is also a method called Welch’s
ANOVA which is like classic ANOVA but handles unequal variances better.
This can be done in R using <code>oneway.test()</code>, but there is
some debate around best practice that is beyond the scope of this post.
<a href="#fn9" class="footnote-ref" id="fnref9"><sup>9</sup></a> It
would be prudent to run the Welch versions of the tests whenever we
suspect the data to be heteroscedastic.</p>
<p>The recurring themes here are: (1) to check for heteroscedasticity
and normality, and (2) to run multiple tests to acquire a more
comprehensive view.</p>
</div>
<div
id="t-tests-anova-and-linear-regression---are-they-completely-different"
class="section level2">
<h2>4.2 t-tests, ANOVA, and linear regression - are they completely
different?</h2>
<p>The common assumptions shared by the three methods may have gave it
away, but the t-test, ANOVA, and linear regression are actually related
in the sense that one is a special case of another.</p>
<p>The t-test is considered a special case of ANOVA, since the classic
Student’s t-test is the same as ANOVA in comparing two groups when
variances are equal. When the t-test statistic is squared, you get the
corresponding f-statistic in the ANOVA.<a href="#fn10"
class="footnote-ref" id="fnref10"><sup>10</sup></a></p>
<p>On the other hand, an ANOVA model is the same as a regression with a
dummy variable. In fact, the <code>aov()</code> function in R is a
wrapper around the linear regression function <code>lm()</code>. Steve
Midway’s <a
href="https://bookdown.org/steve_midway/DAR/understanding-anova-in-r.html"><em>Analysis
in R</em></a> has a chapter which compares the outputs when running
ANOVA using <code>lm()</code> versus <code>aov()</code>.</p>
<p>All of these procedures are subsumed under the General Linear Model
and share the same assumptions.</p>
</div>
</div>
<div id="end-notes" class="section level1">
<h1>End Notes</h1>
<p>This has been a very long post - hope you have found this useful! Due
to the vastness of the subject, it will not be possible to detail every
consideration and method. However, this should hopefully make flow
charts like the below easier to follow:</p>
<div class="figure">
<img
src="https://raw.githubusercontent.com/martinctc/blog/master/images/statistical-tests-decision-tree-grosofsky.png"
alt="" />
<p class="caption">Flowchart for inferential statistics from Grosofsky
(2009)</p>
</div>
<p>Please comment in the Disqus box down below if you have any feedback
or suggestions. Do also check out the References list below for further
reading; as I wrote this I have attempted to link to the brilliant
resources referenced as diligently as possible.</p>
</div>
<div id="references" class="section level1">
<h1>References</h1>
<ul>
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
<li><a
href="https://stats.stackexchange.com/questions/1637/if-the-t-test-and-the-anova-for-two-groups-are-equivalent-why-arent-their-assu">t-test
versus ANOVA for two groups</a></li>
<li><a
href="https://bookdown.org/steve_midway/DAR/understanding-anova-in-r.html">Understanding
ANOVA in R</a></li>
<li><a
href="https://medium.com/git-connected/when-and-why-you-should-use-non-parametric-tests-5ed486a84826">Why
you should use non-parametric tests</a></li>
<li><a
href="https://sphweb.bumc.bu.edu/otlt/MPH-Modules/PH717-QuantCore/PH717-Module9-Correlation-Regression/index.html">Correlation
and Regression</a></li>
</ul>
</div>
<div class="footnotes footnotes-end-of-document">
<hr />
<ol>
<li id="fn1"><p>a scenario in modelling where your predictor variables
are correlated, which could lead to a poor inference.<a href="#fnref1"
class="footnote-back">↩︎</a></p></li>
<li id="fn2"><p>See <a
href="https://learn.microsoft.com/en-us/viva/insights/use/metric-definitions"
class="uri">https://learn.microsoft.com/en-us/viva/insights/use/metric-definitions</a>
for definitions.<a href="#fnref2" class="footnote-back">↩︎</a></p></li>
<li id="fn3"><p>See Mishra P, Pandey CM, Singh U, Gupta A, Sahu C,
Keshri A. Descriptive statistics and normality tests for statistical
data. Ann Card Anaesth. 2019 Jan-Mar;22(1):67-72. doi:
10.4103/aca.ACA_157_18. PMID: 30648682; PMCID: PMC6350423.<a
href="#fnref3" class="footnote-back">↩︎</a></p></li>
<li id="fn4"><p>The other well-known alternative test for normality is
the <strong>Kolmogorov-Smirnoff</strong> test, run in R using
<code>ks.test()</code>. The KS test looks at the quantile where your
empirical cumulative distribution function differs maximally from the
normal’s theoretical cumulative distribution function. This is often
somewhere in the middle of the distribution. On the other hand, the
Shapiro-Wilk test focusses on the tails of the distribution, which is
consistent to what we are seeing the Q-Q plots.<a href="#fnref4"
class="footnote-back">↩︎</a></p></li>
<li id="fn5"><p>References original article at <a
href="https://www.scribbr.com/statistics/anova-in-r/"
class="uri">https://www.scribbr.com/statistics/anova-in-r/</a>.<a
href="#fnref5" class="footnote-back">↩︎</a></p></li>
<li id="fn6"><p>An alternative is the Tukey Honest Significant
Differences (<code>TukeyHSD()</code>), which won’t be detailed here. The
<code>TukeyHSD()</code> function operates on top of the object returned
by <code>aov()</code>.<a href="#fnref6"
class="footnote-back">↩︎</a></p></li>
<li id="fn7"><p>See <a
href="https://stats.stackexchange.com/questions/236877/is-it-wrong-to-use-anova-instead-of-a-t-test-for-comparing-two-means">this
discussion</a> and <a
href="https://stats.stackexchange.com/questions/409503/anova-vs-t-test-for-two-groups">this</a>.<a
href="#fnref7" class="footnote-back">↩︎</a></p></li>
<li id="fn8"><p><a href="https://www.statisticshowto.com/welchs-anova/"
class="uri">https://www.statisticshowto.com/welchs-anova/</a><a
href="#fnref8" class="footnote-back">↩︎</a></p></li>
<li id="fn9"><p>See <a
href="https://statisticsbyjim.com/anova/welchs-anova-compared-to-classic-one-way-anova/"
class="uri">https://statisticsbyjim.com/anova/welchs-anova-compared-to-classic-one-way-anova/</a>;
<a
href="https://blog.minitab.com/en/adventures-in-statistics-2/did-welchs-anova-make-fishers-classic-one-way-anova-obsolete"
class="uri">https://blog.minitab.com/en/adventures-in-statistics-2/did-welchs-anova-make-fishers-classic-one-way-anova-obsolete</a>;
<a
href="http://ritsokiguess.site/docs/2017/05/19/welch-analysis-of-variance/"
class="uri">http://ritsokiguess.site/docs/2017/05/19/welch-analysis-of-variance/</a>.
See also Liu, H. (2015). Comparing Welch ANOVA, a Kruskal-Wallis test,
and traditional ANOVA in case of heterogeneity of variance. Virginia
Commonwealth University.<a href="#fnref9"
class="footnote-back">↩︎</a></p></li>
<li id="fn10"><p>It is worth a quick footnote on the differences between
the t-statistic and the f-statistic. The f-statistic is an output that
is found in both the F-tests for variance (see <code>var.test()</code>)
and ANOVA (see <code>aov()</code>). The f-statistic is a ratio of two
variances, and variance is squared standard deviation. Note that the
f-tests for variance and ANOVA are not the same, as the former compares
variances of two populations whereas the latter compares within- and
between-group variances, even though both tests use the f-distribution.
When there are only two groups for the one-way ANOVA F-test, the
f-statistic is equal to the square of the Student’s t-statistic.<a
href="#fnref10" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
