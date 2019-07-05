---
title: "A Short Essay on Duplicated R Artefacts"

author: "Martin Chan"
date: "July 6, 2019"
layout: post
---


<section class="main-content">
<p><img src="{{ site.url }}{{ site.baseurl }}/images/fog-3622519_1920.jpg" width="80%" /></p>
<div id="organic-development-of-r-artefacts" class="section level2">
<h2>Organic Development of R Artefacts</h2>
<p>In a <a href="https://martinctc.github.io/blog/two-styles-of-learning-r/">previous post</a>, I alluded to the point that one of the great strengths (but also one of the challenges) of R is the organic way in which R ‘artefacts’ are developed.<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> One characteristic of this “organic development” process is as follows.</p>
<blockquote>
<p>Given enough familiarity with R, anyone can create their own package or a tutorial on how to perform a task in R (e.g. create a certain visualisation), and these artefacts can be made available online to the community without having gone through an editorial process.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> As such, the creation of content or artefacts is to a large extent <em>decentralised</em> and <em>unregulated</em>.</p>
</blockquote>
<p>(This is a claim that I will examine, rather than take it to be true or fair as given)</p>
</div>
<div id="is-there-a-problem-with-quality" class="section level2">
<h2>Is there a problem with <strong>quality</strong>?</h2>
<p>If we presume that the above claim regarding decentralisation and lack of regulation is true, does this pose an issue for the R community? The first challenge that comes to mind will be around the <em>quality</em> of the artefacts, where the criticism is that the organic and decentralised way in which content is being developed renders them at risk of being <strong>low quality</strong>.</p>
<p>I disagree that this is the case, and if anything is problematic with the way that R artefacts are being developed I don’t think it lies with their quality.</p>
<p>Here’s why: the existence of platforms enabling conversations between R developers and users to take place (e.g. GitHub, Stack Overflow, Twitter, the R blogosphere, CRAN) naturally generate checks and encourage actions that iteratively <em>improve</em> the artefacts over time. For instance, upon spotting a new bug with a package, anyone can easily log an issue on GitHub or Stack Overflow, and in time the developer(s) of that package would then (heroically!) resolve that problem. The general activeness and helpfulness of the R community itself is certainly a further key factor in enabling this process to work so effectively.</p>
</div>
<div id="a-concern-with-duplication" class="section level2">
<h2>A concern with duplication</h2>
<p>My concern, or at least the concern that is the main object of this post, is with the apparent <em>duplication</em> that comes with such an organic process of content creation in R. Examples of such duplication are functions that can perform the same task existing across different packages, or different tutorials that teach you how to do the same task in terms of outcome but implemented in different syntax (with no practical differences in performance).</p>
<p>Redundancy in small doses are harmless, and even advantageous as it offers choice to the R user. However, the challenge begins to emerge when redundancies exist in large numbers, and it becomes time-consuming for the R user to navigate through large volumes of content to identify the best and right option for them. A well-known example may be the number of methods available in R to read in CSV files (see <a href="https://www.r-bloggers.com/fast-data-loading-from-files-to-r/">this discussion</a>); in an older post I also noted several methods for <a href="https://martinctc.github.io/blog/working-with-spss-labels-in-r/">accessing variable labels in R</a>.</p>
<p>For someone who is new to R the amount of duplication can be confusing, and additional research or “exploration” time is required to figure out the best method. Anecdotally, from speaking to friends and colleagues who are trying to learn R, the large number of methods available to a simple given (usually basic) task is one of the top barriers to getting to grips with R.</p>
<p>(Note that arguing that such duplications aren’t <em>true</em> duplications as the functions have performance differences per say doesn’t quite defeat the criticism, as these differences are likely to make little practical difference to the beginner)</p>
</div>
<div id="what-does-this-mean" class="section level2">
<h2>What does this mean?</h2>
<p>Based on how the R community has continued to grow and flourish with an ever increasing number of new users, there’s a counter argument that says that the benefits of having more <strong>choice</strong> outweighs the costs of <strong>duplication</strong>. Whilst this may be true, I think a more actionable and practical conclusion would be to say that there is now, more than ever before, a greater need for work that unifies, compares, and evaluates the existing artefacts in the R community. The scope of such “unification work” can range from small to ambitious:</p>
<ul>
<li>Blog posts, vignettes, or online discussions (even Twitter) on how packages compare with one another (e.g. posts on data.table vs dplyr, sjlabelled vs labelled, rpart vs party) - performing almost a kind of ‘literature review’ function</li>
<li>Posts that link heavily to existing blog posts or documentation on R, so that readers can more easily access the content that has been created before</li>
<li>Grand projects that unify package syntax (<strong>tidyverse</strong>?)</li>
</ul>
<p>A lot of this is already being done of course, and the R community has been doing this since almost as early as R blogs or forums have existed. The purpose and value of these activities and content is to bring together what’s being created out there in the R community, and overcome the problem of <strong>duplication</strong> whilst preserving the <strong>advantages of an organic, decentralised system of artefact / content creation</strong>. Without the continued efforts of R users in sharing their comparisons of functions, packages, and content in general, the world of R would become very difficult to navigate indeed.</p>
<p>The conclusion therefore isn’t a dire one that R should become more centralised, or that the R community will become unsustainable in the long term. I think the conclusion is more that: if you are a regular R user, keep asking questions and keep sharing thoughts, because it is the <em>activeness</em> of the community that makes the entire open source project work so well. If you are a content creator in R, spend a bit more time looking at what’s already out there and consider that the value of integrating somebody else’s work can be as high as (if not higher than) creating something entirely from scratch on your own.<a href="#fn3" class="footnote-ref" id="fnref3"><sup>3</sup></a></p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>I refer to <strong>artefacts</strong> in this post as a broad term for “things” created by the R community, including blogs, vignettes, packages, books, podcasts, and videos. <em>Content</em> is probably a more commonly used term, but I particularly liked the connotations of <em>artefact</em> around legacy, i.e. that once a piece of R content is created it leaves a lasting impact for the entire R community.<a href="#fnref1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p>Sure, if you’re intending to publish your package on CRAN you would have to go through a series of stringent checks, but my point is that it’s possible to share your package (say, on GitHub) without any process of review.<a href="#fnref2" class="footnote-back">↩</a></p></li>
<li id="fn3"><p>This is partly a note to myself, as I certainly have previously created duplicated R artefacts without checking properly whether something else similar is already out there.<a href="#fnref3" class="footnote-back">↩</a></p></li>
</ol>
</div>
</section>
