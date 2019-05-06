---
title: "Two Styles of Learning R"

author: "Martin Chan"
date: "May 6, 2019"
layout: post
---


<section class="main-content">
<blockquote>
<p>What’s the best way to learn R?</p>
</blockquote>
<div id="motivations-behind-the-debate" class="section level2">
<h2>Motivations behind the debate</h2>
<p>Some argue that R fundamentally has a steep learning curve, and argue there are no real shortcuts for learning R. I don’t completely agree with that: I think that there are easier ways to learn R nowadays, specifically with the availability and expansion of the tidyverse collection of packages. From my own experience, and from chatting with other people about their experiences in self-teaching R, I think that learning approaches for R (especially at the “newbie” stage) fall into either one of two styles: the <strong>‘anarchic’</strong> style and the <strong>‘methodical’</strong> style. There’s a valuable debate to be had on which approach/style is better, and I’m sure someone from the <a href="https://twitter.com/search?q=%23rstats">#rstats</a> community has discussed this at some point. Nonetheless, I do feel that it’s worth outlining this question as it is quite an important one, as making the learning of R accessible to a wide audience is key to the continuous thriving of the R community, its artefacts (e.g. packages, analysis outputs), and the language itself. If you want more people to use R, you have to make it easier for them to learn R.</p>
<div class="figure">
<img src="{{ site.url }}{{ site.baseurl }}\images\CiSMsEpXEAATXry.jpg" alt="Source:  https://twitter.com/rogierK/status/730863729420701697" width="80%" style="float:bottom; padding:10px" />
<p class="caption">
Source: <a href="https://twitter.com/rogierK/status/730863729420701697" class="uri">https://twitter.com/rogierK/status/730863729420701697</a>
</p>
</div>
</div>
<div id="the-anarchic-style" class="section level2">
<h2>The ‘Anarchic’ Style 🤔</h2>
<p>The first style is what I (rather dramatically) refer to as the ‘anarchic’ style, or the ‘greedy’ style; many R users I know and certainly myself fall into this camp. By an <strong>anarchic</strong> learning style, I am referring to an “anything goes” style of learning that follows no rule or principle in selecting the source and method for learning R. For example, this means you don’t simply stick to a particular book or a tutorial, but rather absorb knowledge about R indiscriminately through whatever source you come across, including:</p>
<ul>
<li>Stack Overflow discussions</li>
<li>RPubs documents / vignettes on GitHub</li>
<li>R blogs on <a href="https://www.r-bloggers.com/">R-bloggers</a> or <a href="https://rweekly.org/">R Weekly</a></li>
<li>YouTube videos</li>
<li>Structured tutorial videos on DataCamp / Udemy, etc.</li>
</ul>
<p>Most people who are learning R on their own without a mentor would probably naturally lean towards this style, as the lack of guidance means that there is a especially a need to explore different mediums and methods to find out what works best for you.</p>
<p>What’s characteristic about this style is that it is <em>knowledge gap-driven</em> and <em>method-agnostic</em>: you focus on what your knowledge gaps are, and explore methods indiscriminately with the sole aim of filling the gap. For instance, I might be a beginner in R with no background in natural language processing or text mining, and decide that I want to learn to run some basic text analysis in R for some Twitter posts I got my hands on. Instead of identifying a single good book or tutorial that introduces you to the basic concepts and operations such as n-grams, word-stemming and creating document-term matrices, as an ‘anarchic’ learner I would scour the Internet for any blogs, Stack Overflow discussions, vignettes and videos that contain the terms “text mining”, “analysis”, and “in R”, and try to make sense of all the information that I come across.</p>
<p>If the above is a somewhat representative description of your learning style, you’re probably well aware of its advantages and disadvantages. On the one hand, you are likely to end up with a very comprehensive view of what’s out there - along the way, you’ll probably learn how to download books through R (see <a href="https://cran.r-project.org/web/packages/gutenbergr/vignettes/intro.html">gutenbergr</a>) and create interactive wordclouds (see <a href="https://cran.r-project.org/web/packages/wordcloud2/vignettes/wordcloud.html">wordcloud2</a>), even if you weren’t necessarily looking out for how to do these things in the first place! You’ll realise that there are at least two major R packages available out there for text mining (<a href="http://tm.r-forge.r-project.org/">tm</a> and <a href="https://github.com/juliasilge/tidytext">tidytext</a>), and if you’ve spent enough time learning, you’ll probably also have figured out two or more different ways of doing pretty much the same thing.</p>
<p>All sounds great, but on the other hand this style of learning is painfully <em>inefficient</em>: if your ultimate goal is to be able to run a word frequency analysis, why would you need to learn two ways of doing it? Whilst these may serve as valuable lessons in the long term, isn’t it a poor use of time to trawl through and experiment with the ‘good’ and ‘less good’ methods that other users have come up with, in order to figure out how to do this yourself? The inefficiency of this approach also makes it much more likely that someone will <em>give up</em> on learning, especially if this is somebody who is learning on the job or isn’t learning R full-time.</p>
<p>The problem of inefficiency partly lies with the diverse nature of R’s package eco-system: packages are largely written by individual contributors and developers, not by a single team of developers sitting in the same office. Since this is a distributed process, it’s almost inevitable that there will be duplications, or very similar methods to achieve the same thing in R (just think about how many ways you can filter rows in R). I wouldn’t change this about R at all, as I think this is part of what makes R such a great language; however, this does pose a very material obstacle for new comers to R. As someone who learnt R through the ‘anarchic’ approach, there were many times that I felt frustrated simply because the available learning resources had inconsistent syntax styles (e.g. dplyr vs data.table vs base), and so much time was spent simply trying to figure out what I really needed to know in order to do the thing that I wanted to do.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\r-learning-debate.png" width="40%" style="float:right; padding:10px" /></p>
</div>
<div id="the-methodical-style" class="section level2">
<h2>The ‘Methodical’ Style</h2>
<p>So here’s the alternative - the ‘Methodical’ Style - which is simply the opposite of the ‘Anarchic’ approach.</p>
<p>Instead of ‘greedily’ consuming all the information that is available and accessible, this style applies a much stricter discipline in selecting sources of information. For instance, one might choose to learn and stick to <a href="https://r4ds.had.co.nz/">R for Data Science</a> as the core textbook to go through, rather than dipping into older textbooks that might use a mixture of base R code and possibly reference bits of dplyr syntax. The idea is that this more disciplined style works well to quickly onboard new learners on how to run analysis in R using the more intuitive tidyverse style, and only at a later stage expose the learners to more complex concepts and syntax in R once they have greater familiarity with the language. The argument is also that since new learners can much quickly achieve some ‘easy wins’ and are less likely to get confused with this approach, the drop-off rate (i.e. giving up) at the early stages will be lower and hence are much more likely to convert into fluent R users.</p>
</div>
<div id="which-style-is-better" class="section level2">
<h2>Which style is better?</h2>
<p>When I first started learning R (~ 2014), tidyverse wasn’t quite as developed or well-known, and the only kind of methodical learning approach available was to learn base R - which wasn’t quite as intuitive or accessible for a beginner. Today, tidyverse presents a clearly better alternative. My view is that new learners who have zero or very limited experience of programming should apply the ‘Methodical’ style and learn the tidyverse syntax, and only switch to a more ‘greedy’ style when they start to get to grips with functional programming or more advanced applications of R. The ‘anarchic’ / ‘greedy’ style is ultimately important because it enables you to take a comprehensive view of the solutions which are out there in the R universe, and this comprehensive view is essential for coming up with creative and tailored solutions to real-life analytical problems.<a href="#fn1" class="footnoteRef" id="fnref1"><sup>1</sup></a></p>
<p>Related reading: Kai Arzheimer’s <a href="https://www.kai-arzheimer.com/how-the-tidyverse-changed-my-view-of-rstats/">blog on how tidyverse changed his view on rstats</a></p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>See a previous <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/">post</a> where I discuss an approach combining the readability of magrittr pipes and the speed of data.table.<a href="#fnref1">↩</a></p></li>
</ol>
</div>
</section>
