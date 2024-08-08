---
title: "First World Problems: Very long RMarkdown documents"

author: "Martin Chan"
date: "September 8, 2019"
layout: post
tags: vignettes rmarkdown r
image: https://martinctc.github.io/blog/images/fwp-rmarkdown.png
---


<section class="main-content">
<div id="rmarkdown-is-awesome" class="section level2">
<h2>RMarkdown is awesome!</h2>
<p>When I first started using <a href="https://rmarkdown.rstudio.com/">RMarkdown</a>, it felt very much like a blessing.</p>
<p>Not only does the format encourage reproducible analysis by enabling you to interweave code, text, images, and plots, it also allows you to <code>knit()</code> the document into so many different formats, including static HTML, MS Word, PowerPoint, PDF - <strong>everything done from the comfort of the RStudio IDE!</strong></p>
<p>I also love the fact that whilst the outputs are highly customisable (e.g. adding your own CSS), it is also incredibly easy to produce a professional document by using an existing template (e.g. see <a href="https://github.com/yixuan/prettydoc">prettydoc</a> and <a href="https://github.com/juba/rmdformats">rmdformats</a>). In fact, this blog post itself is written using RMarkdown. If you haven’t tried RMarkdown yet, I’d highly recommend it - and <em>R Markdown: The Definitive Guide</em> <a href="https://bookdown.org/yihui/rmarkdown/">is a good place to start</a>.</p>
<p>But this post isn’t about selling RMarkdown. Actually, it’s about a relatively trivial inconvenience* I’ve recently experienced when using RMarkdown in work, and how I’ve found a simple solution to overcome this issue.</p>
<p>*hence first world problem</p>
</div>
<div id="rmarkdown-documents-that-are-too-long" class="section level2">
<h2>RMarkdown documents that are too long!</h2>
<p><img src="https://martinctc.github.io/blog/images/fwp-rmarkdown.png" width="80%" style="padding:10px" /></p>
<p>I quite often use RMarkdown to document my data exploratory analysis - e.g. when I’m coming across a completely new set of data.</p>
<p>The problem is simple: as I explore different cuts of the data and layer more plots, tables, and text onto my RMarkdown document, it gets unmanageably long (1,000 lines+). Although I can create more functions and <code>source()</code> them externally from a separate R file where possible, there is a limit to how much I can shorten the length of the Rmd file. As the file gets longer, errors become more common and debugging becomes more difficult.</p>
<p>However, it is not completely straightforward to split a RMarkdown document into multiple files and use <code>source()</code> to combine them into a single document, because <code>source()</code> doesn’t work on RMarkdown documents. A RMarkdown document contains more than just R code, and what you’d ideally want is to be able to combine both the code chunks and the accompanying text commentary. So I did some digging on Stack Overflow and found a solution that I was pretty happy with.<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a></p>
</div>
<div id="the-solution" class="section level2">
<h2>The solution</h2>
<p>The first step I did was to get my RMarkdown ‘contents’ into multiple files that fit into the following structure:</p>
<ul>
<li><p><strong>The “Mother” Rmd</strong> - this is the file that will take in all the content from the “child” Rmd. I would keep this file relatively short and usually just use this for loading packages and functions. This is the <em>only</em> Rmd file that should have a YAML header (the starting bits specifying title, author, and knit output options). There should only be <strong>one</strong> “Mother” Rmd.</p></li>
<li><p><strong>“Child” Rmd(s)</strong> - these files would hold most of the analysis and be read into the “Mother” Rmd. You can have more than one of these “Child” Rmd files, and apart from the fact that these files won’t have a YAML header, they should be no different from a typical Rmd file. They’ll still have the same .Rmd file extension, and you can do section headers (e.g. h1, h2, h3…) and code chunks as normal.</p></li>
</ul>
<p>My habit is then to have my working directory in the following structure, where my RMarkdown files are all saved in a <strong>Rmd</strong> sub-folder under a <strong>Scripts</strong> folder, separate from my functions. The example below shows a <strong>mother</strong> Rmd file called <em>main_analysis_file.Rmd</em>, and four child Rmd files named <em>analysis-part1.Rmd</em>, <em>analysis-part2.Rmd</em>, and so on:</p>
<ul>
<li>root project directory
<ul>
<li><strong>Data</strong> - <em>where I save my raw data</em></li>
<li><strong>Output</strong> - <em>where I save my analysis and plot outputs</em></li>
<li><strong>Scripts</strong>
<ul>
<li><strong>Rmds</strong> - <em>save all Rmd scripts here</em>
<ul>
<li>main_analysis_file.Rmd [mother]</li>
<li>analysis-part1.Rmd [child]</li>
<li>analysis-part2.Rmd [child]</li>
<li>analysis-part3.Rmd [child]</li>
<li>analysis-part4.Rmd [child]</li>
</ul></li>
<li><strong>Functions</strong> - <em>save functions here</em></li>
</ul></li>
</ul></li>
</ul>
<p>Once I’ve organised all my analysis in the individual child Rmd files, all I need to do is to “source” these Rmd files into the “mother” file. Instead of using <code>source()</code>, I’ll use code chunks in the “mother” Rmd file. To make the file path referencing a bit more easier to deal with, I use <code>here::here()</code> to help R find the right Rmd files:<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a></p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/child_code_chunks.png" width="100%" style="float:left; padding:10px" /></p>
<p>Note that you don’t need to include anything in those R code chunks within the “mother” Rmd. If everything has worked, <code>knit</code>-ting from the “mother” Rmd file should get you an output that draws from all the children Rmd.</p>
<p>Then that’s pretty much it! The outcome is that you still get outputs that contain the entire analysis, but code and documentation that is better organised and much easier to follow.</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p><a href="https://stackoverflow.com/a/25979000/5539702">See this Stack Overflow solution</a> that solved my problem. This solution is more suited for organising analysis projects, but <a href="https://github.com/rstudio/bookdown">bookdown</a> may be more suitable if you’re writing a book or a thesis.<a href="#fnref1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p>See <a href="https://github.com/jennybc/here_here">here</a> for more on Jenny Bryan’s <strong>here</strong> package.<a href="#fnref2" class="footnote-back">↩</a></p></li>
</ol>
</div>
</section>
