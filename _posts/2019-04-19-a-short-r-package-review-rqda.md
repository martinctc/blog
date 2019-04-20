---
title: "A Short R Package Review: RQDA"

author: "Martin Chan"
date: "April 19, 2019"
layout: post
---


<section class="main-content">
<div id="a-favourite-r-package" class="section level3">
<h3>A favourite R package?</h3>
<p>Whenever I’m asked the question of what my <em>favourite</em> R package is, I often go through this reasoning: <a href="https://www.tidyverse.org/">tidyverse</a> packages, such as <a href="https://dplyr.tidyverse.org/">dplyr</a> and <a href="https://tidyr.tidyverse.org/">tidyr</a>, are what I’d call “essentials” i.e. packages that I would always load for almost every piece of analysis in R. I love tidyverse, but when we are talking about a <em>favourite</em> package, they do not feel quite like the right candidates. The reason is because tidyverse packages are so intrinsic to my personal routine of using R that it’s almost like saying “Water is my favourite drink because I can’t live without it.” Plus, answering that tidyverse is my favourite package feels like I’m not putting much of an effort in the answer at all! 😄</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\one-does-not-simply-pick-a-favourite-r-package.jpg" width="40%" style="float:right; padding:10px" /></p>
<p>Other candidates include useful “specialist” packages<a href="#fn1" class="footnoteRef" id="fnref1"><sup>1</sup></a>, such as <a href="https://github.com/juliasilge/tidytext">tidytext</a> and <a href="http://tm.r-forge.r-project.org/">tm</a> for text mining, <a href="https://github.com/ardata-fr/mschart">mschart</a> and <a href="https://davidgohel.github.io/officer/">officer</a> for manipulating Office documents, as well as <a href="https://rstudio.github.io/shinydashboard/">shinydashboard</a> and <a href="https://github.com/rstudio/flexdashboard">flexdashboard</a> for creating either dynamic or static dashboard outputs. But that doesn’t make the decision easy either - I love how each of these packages work so well for the purpose that they are designed for, and most of these are very well-maintained, documented, with plenty of vignettes (some have entire books written around the package - see <a href="https://www.tidytextmining.com/">tidytext</a>) for users to follow through examples. You can’t compare them based on “value added” either, as the value they add to a workflow does depend entirely on what you are trying to achieve in an analysis or output.</p>
<p>The final approach that I usually take is what one could describe as a test on <em>emotive impact</em> i.e. <em>which package, in my experience of learning to do things with R, made the largest impression on me?</em></p>
<blockquote>
<p>which package, in my experience of learning to do things with R, made the largest impression on me?</p>
</blockquote>
<p>Now, this question is much easier to answer, firstly because the criteria are relaxed on the performance, quality, and the use-value of the package, and secondly the focus is more around my personal experience with the package in the past.</p>
</div>
<div id="rqda---qualitative-data-analysis-in-r" class="section level3">
<h3>RQDA - Qualitative Data Analysis in R</h3>
<p>The first answer that comes to mind is a package written by Huang Ronggui called <a href="https://github.com/Ronggui/RQDA">RQDA</a>, which stands for <em>R-based Qualitative Data Analysis</em>. In my previous life working in market research, I had worked on a number of qualitative projects which involved conducting semi-structured interviews with customers. These interviews tend to be fairly open-ended conversations lasting from half an hour to two hours, and are importantly different from <strong>surveys</strong> because there are no pre-set answers to select from or even questions. As a moderator, you are supposed to allow a conversation to develop naturally, and steer it in a way through prompts so that it helps you understand the motivations and the experience of customer journeys.</p>
<p>From a data point-of-view, the output of these interviews come through as text transcripts (created from audio recordings) - effectively, as large bodies of unstructured text saved in Word documents. The data analyst’s instinct is perhaps to run some form of word or n-gram frequency analysis, but this often fails to uncover or capture the valuable themes or contextual information that researchers are looking after. Traditionally, market researchers analyse qualitative data in a manual, not-so-systematic approach - by reading through the transcripts, highlighting themes and quotes, and almost through ‘mental impression’ piece together a narrative or a set of implications that arise from the analysis. It almost goes without saying that this approach isn’t ideal either, as it is unscalable, prone to human error, excessively reliant on human memory, and does not lend itself to collaborative analysis.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\rqda-gui.PNG" width="40%" style="float:right; padding:10px" /></p>
<p>Enter RQDA: a package that combines the benefits of human interpretation and systematic, computer-assisted analysis. When you run <code>library(RQDA)</code>, the package launches a GUI (using RGtk2) that allows you to import text files and manually highlight and classify chunks of text into themes (which is what market researchers do anyway when highlighting Word documents).</p>
<p>What’s amazing about RQDA is that it generates a SQLite database in the back-end (as an RQDA object), which you can then query with SQL (using <a href="https://github.com/r-dbi/RSQLite/">RSQlite</a>) to answer questions like the co-occurence of themes from an interview, or whether certain themes come up more often when a respondent is a millennial versus an “empty-nest” pensioner. If you do choose to run any form of text analytics, the enables you to get much further as the thematic analysis covers off any contextual and nuanced information that a straight text mining exercise wouldn’t likely to have been able to capture. Even if you don’t run any text analytics, RQDA already improves on the ‘informal’ method of analysis by having all the quotes, themes, and classification of respondents organised in a very accessible structure. For instance, you can very easily check whether your narrative makes sense by identifying the quotes that relate to a certain theme.</p>
<p>Other nifty features of the RQDA package include: - Export coded / marked-up transcripts as HTML - Export all codings / marked-up text as HTML - Automated coding through keyword match, e.g. if the paragraph contains “dietician”, code to the theme “Reference to dietician”</p>
<p>Here are some code snippets that I’ve used in the past, which became very handy:</p>
<div class="sourceCode"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Extract the full transcript from the SQLite database</span>
<span class="kw">RQDAQuery</span>(<span class="dt">sql=</span><span class="st">&quot;SELECT name, file FROM source&quot;</span>)

<span class="co"># Automated coding - for the keyword &quot;hacking&quot;</span>
<span class="co"># cid refers to the code / theme id</span>
<span class="kw">codingBySearch</span>(<span class="st">&quot;hacking&quot;</span>,<span class="dt">fid =</span> <span class="kw">getFileIds</span>(), <span class="dt">cid =</span> <span class="dv">22</span>)

<span class="co"># Export All Codings as HTML file </span>
file_prefix &lt;-<span class="st"> &quot;PROJECTCODE CONTENT&quot;</span> <span class="co"># Customise file name</span>
cod.name &lt;-<span class="st"> </span><span class="kw">timed_fn</span>(file_prefix,<span class="st">&quot;.html&quot;</span>)
<span class="kw">exportCodings</span>(<span class="dt">file=</span>cod.name)</code></pre></div>
</div>
<div id="conclusion" class="section level3">
<h3>Conclusion?</h3>
<p>The reason why RQDA made such a impression on me is because I came across it at as a beginner in R, and the fact that such a package existed at all to accommodate such a specific analysis need really made me realise the potential and versatility of the R community and its packages - especially when people tend to associate statistical analysis with R, and not with qualitative research. I’d say RQDA is a pretty fit-for-purpose, reasonably well-documented (could do with more vignettes), but you’re unlikely to use it unless you do have to work on a sizeable qualitative project with multiple transcripts.</p>
</div>
<div id="rating" class="section level3">
<h3>Rating 🌟</h3>
<ul>
<li><p><strong>Fit-for-purpose</strong>: 4.5/5 - You can run a full qualitative project with RQDA. From my own experience, I used RQDA to achieve everything I wanted to achieve from NVivo, another computer-assisted qualitative data analysis software (but is not open-source).</p></li>
<li><p><strong>Quality of Documentation</strong>: 4/5 - Could benefit from more vignettes with practical examples. The <a href="http://rqda.r-forge.r-project.org/">package site</a> is very detailed though. There are some old but still pretty useful YouTube videos out there which were really helpful to me when I learnt it.<a href="#fn2" class="footnoteRef" id="fnref2"><sup>2</sup></a></p></li>
<li><p><strong>Easy to learn</strong>: 4/5 - You can do a fair amount even if you don’t do SQL queries - the GUI interface certainly helps, even if you are a beginner in R.</p></li>
<li><p><strong>Features</strong>: 3.5/5 - could have options to enable pretty plotting of network graphs. You do need to put in a bit more work to get out the data out for pretty visualisation.</p></li>
</ul>
<iframe width="560" height="315" src="https://www.youtube.com/embed/mLsyGH3ztYY" frameborder="0" allowfullscreen>
</iframe>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>“Specialist” as in designed for a specific area of analysis, as opposed to <strong>dplyr</strong>, or <strong>data.table</strong>, which are general packages that you would need for any kind of analysis.<a href="#fnref1">↩</a></p></li>
<li id="fn2"><p>Check out Mekin Caliskan’s <a href="https://www.youtube.com/user/RQDAtuto">videos</a> on RQDA. I’ve embedded his introduction to RQDA video below:<a href="#fnref2">↩</a></p></li>
</ol>
</div>
</section>
