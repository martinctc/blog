---
title: "Vignette: Downloadable tables in RMarkdown with the DT package"

author: "Martin Chan"
date: "December 25, 2019"
layout: post
tags: vignettes rmarkdown excel r
image: https://raw.githubusercontent.com/martinctc/blog/master/images/dashboard-excel-flexdashboard-meme.jpg
---


<section class="main-content">
<div id="background" class="section level2">
<h2>Background</h2>
<p>In an earlier post April this year, I discussed using <a href="https://martinctc.github.io/blog/my-favourite-alternative-to-excel-dashboards/">flexdashboard</a> (with <strong>RMarkdown</strong>) as an appealing and practical R alternative to Excel-based reporting dashboards. Since it’s possible to (i) export these ‘flexdashboards’ as static HTML files that can be opened on practically any computer (virtually no dependencies), (ii) shared as attachments over emails, and (iii) run without relying on servers and Internet access, they rival ‘traditional’ Excel dashboards on <em>portability</em>. This is an advantage that you don’t really get with other dashboarding solutions such as Tableau and <strong>Shiny</strong>, as far as I’m aware.</p>
<p>Traditionally, people also like Excel dashboards for another reason, which is that all the data that is reported in the dashboard is usually <em>self-contained</em> and available in the Excel file in itself, provided that the source data within Excel isn’t hidden and protected. This enables any keen user to extract the source data to produce charts or analysis on their own “off-dashboard”. Moreover, having the data available within the dashboard itself helps with <em>reproducibility</em>, in the sense that one can more easily trace back the relationship between the source data and the reported analysis or visualisation.</p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/dashboard-excel-flexdashboard-meme.jpg" /></p>
<p>In this post, I am going to share a trick on how to implement this feature within <strong>RMarkdown</strong> (and therefore means you can do this in <strong>flexdashboard</strong>) such that the users of your dashboards can export/download your source data. This will be implemented using the <a href="https://rstudio.github.io/DT/">DT</a> package created by <a href="https://rstudio.com/">RStudio</a>, which provides an R interface to the JavaScript library <a href="https://datatables.net/">DataTables</a>.<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a></p>
<p>(Credits to <a href="https://datastrategywithjonathan.com/">Jonathan Ng</a> for sharing this trick with me in the first place! His original video tutorial that first mentions this is available <a href="https://www.youtube.com/watch?v=ux2tQqgY8Gg">here</a>)</p>
</div>
<div id="the-dt-package" class="section level2">
<h2>The DT package</h2>
<p>In a nutshell, <a href="https://github.com/rstudio/DT">DT</a> is a R package that enables the creation of interactive, pretty HTML tables with fancy features such as filter, search, scroll, pagination, and sort - to name a few. Since <strong>DT</strong> generates a <a href="https://www.htmlwidgets.org/showcase_leaflet.html">html widget</a> (e.g. just like what <strong>leaflet</strong>, <strong>rbokeh</strong>, and <strong>plotly</strong> do), it can be used in RMarkdown HTML outputs and Shiny dashboards. I’ve personally found <strong>DT</strong> very useful when creating RMarkdown documents (knitted to HTML) because it allows you to create professional-looking, business-ready interactive tables with literally only a couple of lines of code, and you can do this entirely in R without knowing any JavaScript. The other alternative packages that perform a similar job of producing quick and pretty HTML tables are <a href="https://github.com/renkun-ken/formattable">formattable</a>, <code>knitr::kable()</code> and <a href="https://github.com/haozhu233/kableExtra">kableExtra</a>, but as far as I’m aware only <strong>DT</strong> allows you to add these ‘data download’ buttons that we are focussing on in this post.</p>
</div>
<div id="downloadable-tables" class="section level2">
<h2>Downloadable tables</h2>
<p>What we are trying to get to is an interactive table with buttons that allow you to perform the following actions:</p>
<ul>
<li>Copy to clipboard</li>
<li>Export to CSV</li>
<li>Export to Excel</li>
<li>Export to PDF</li>
<li>Print</li>
</ul>
<p>Though you might only require only one or two of the above buttons, I’m going to go through an example that lets you do all five at the same time. The below is what the <a href="https://martinctc.github.io/blog/examples/dt-download-example.html">final output</a> looks like, using the <code>iris</code> dataset, where the download options are shown at the top of the widget:</p>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/dt-downloadable.PNG" /></p>
<p>To see what the interactive version is like, click <a href="https://martinctc.github.io/blog/examples/dt-download-example.html">here</a>.</p>
</div>
<div id="the-solution" class="section level2">
<h2>The Solution</h2>
<p>The main function from <strong>DT</strong> to create the interactive table is <code>DT::datatable()</code>. The first argument accepts a data frame, so this makes it easy to use it with <strong>dplyr</strong> / <strong>magrittr</strong> pipes. This is how we will create the above table, using the inbuilt <code>iris</code> dataset:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(tidyverse)
<span class="kw">library</span>(DT)

iris <span class="op">%&gt;%</span>
  <span class="kw">datatable</span>(<span class="dt">extensions =</span> <span class="st">&#39;Buttons&#39;</span>,
            <span class="dt">options =</span> <span class="kw">list</span>(<span class="dt">dom =</span> <span class="st">&#39;Blfrtip&#39;</span>,
                           <span class="dt">buttons =</span> <span class="kw">c</span>(<span class="st">&#39;copy&#39;</span>, <span class="st">&#39;csv&#39;</span>, <span class="st">&#39;excel&#39;</span>, <span class="st">&#39;pdf&#39;</span>, <span class="st">&#39;print&#39;</span>),
                           <span class="dt">lengthMenu =</span> <span class="kw">list</span>(<span class="kw">c</span>(<span class="dv">10</span>,<span class="dv">25</span>,<span class="dv">50</span>,<span class="op">-</span><span class="dv">1</span>),
                                             <span class="kw">c</span>(<span class="dv">10</span>,<span class="dv">25</span>,<span class="dv">50</span>,<span class="st">&quot;All&quot;</span>))))</code></pre></div>
<p>And here is a brief explanation for each of the arguments used in the above code:</p>
<ul>
<li><p><strong>extensions</strong>: this takes in a character vector of the names of <a href="https://rstudio.github.io/DT/plugins.html">DataTables plug-ins</a>, but only plugins supported by the DT package can be used here. We’ll just put ‘Buttons’ here.</p></li>
<li><p><strong>options</strong>: this argument is where you feed in all the additional customisation options, which is specified in a list.<a href="#fn2" class="footnote-ref" id="fnref2"><sup>2</sup></a> I usually think of these as ‘expanded features’ that aren’t / haven’t been built into the <strong>DT</strong> package yet, but are available in the ‘source’ JavaScript library <strong>DataTables</strong>.</p>
<ul>
<li><p><strong>dom</strong>: This argument defines the table control elements to appear on the page and in what order. Here, we have specified this to be <code>Blfrtip</code>, where:</p>
<ul>
<li><p><code>B</code> stands for <strong>b</strong>uttons,</p></li>
<li><p><code>l</code> for <strong>l</strong>ength changing input control,</p></li>
<li><p><code>f</code> for <strong>f</strong>iltering input,</p></li>
<li><p><code>r</code> for p<strong>r</strong>ocessing display element,</p></li>
<li><p><code>t</code> for the <strong>t</strong>able,</p></li>
<li><p><code>i</code> for table <strong>i</strong>nformation summary,</p></li>
<li><p>and finally, <code>p</code> for <strong>p</strong>agination display.</p></li>
</ul>
<p>You may move the letters around to control for where the buttons are placed, where for instance <code>lfrtipB</code> would place the buttons at the very bottom of the widget.</p></li>
<li><p><strong>buttons</strong>: you pass a character vector through to specify what buttons to actually display in the widget, where ‘copy’ stands for copy to clipboard, ‘csv’ stands for ‘export to csv’, etc.</p></li>
<li><p><strong>lengthMenu</strong>: this allows you to specify display options for how many rows of data to display on each page. Here, I’ve passed a list through with two vectors, where the first specifies the page length values and the second the displayed options.</p></li>
</ul></li>
</ul>
<p>Try it out! Note that if you run this code in a R script, the table will open up in your Viewer Pane in RStudio, but you will need to run the code within a <strong>RMarkdown</strong> document in order to produce a share-able HTML output.</p>
</div>
<div id="create-a-function-for-cleaner-code" class="section level2">
<h2>Create a function (for cleaner code)</h2>
<p>I’ve wrapped the solution in a handy function called <code>create_dt()</code>, which just adds a bit of convenience as I can simply load this script at the beginning of a RMarkdown document and then call the function throughout the document, whenever I want to display the data and make them downloadable. Here it is:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r">create_dt &lt;-<span class="st"> </span><span class="cf">function</span>(x){
  DT<span class="op">::</span><span class="kw">datatable</span>(x,
                <span class="dt">extensions =</span> <span class="st">&#39;Buttons&#39;</span>,
                <span class="dt">options =</span> <span class="kw">list</span>(<span class="dt">dom =</span> <span class="st">&#39;Blfrtip&#39;</span>,
                               <span class="dt">buttons =</span> <span class="kw">c</span>(<span class="st">&#39;copy&#39;</span>, <span class="st">&#39;csv&#39;</span>, <span class="st">&#39;excel&#39;</span>, <span class="st">&#39;pdf&#39;</span>, <span class="st">&#39;print&#39;</span>),
                               <span class="dt">lengthMenu =</span> <span class="kw">list</span>(<span class="kw">c</span>(<span class="dv">10</span>,<span class="dv">25</span>,<span class="dv">50</span>,<span class="op">-</span><span class="dv">1</span>),
                                                 <span class="kw">c</span>(<span class="dv">10</span>,<span class="dv">25</span>,<span class="dv">50</span>,<span class="st">&quot;All&quot;</span>))))
}</code></pre></div>
<p>You can customise this function to suit whatever needs you have for your project, but I find creating a function for the task of generating <strong>DT</strong> tables just makes the overall code cleaner, shorter, and easier to follow.</p>
</div>
<div id="end-notes" class="section level2">
<h2>End notes</h2>
<p>Hope you enjoyed this short vignette.</p>
<p>Do comment down below if you find this useful, or if you have any related ideas or suggestions you’d like to share. If you liked this post, please do check out my <a href="https://martinctc.github.io/blog/">blog</a> for more R and data science related content.</p>
<p>And have a Merry Christmas everyone!</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>Not to be confused with the <a href="https://github.com/Rdatatable/data.table">data.table</a> package, which is practically a “super” package for <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/">fast data manipulation and wrangling</a>.<a href="#fnref1" class="footnote-back">↩</a></p></li>
<li id="fn2"><p>See <a href="https://datatables.net/reference/option/" class="uri">https://datatables.net/reference/option/</a> for a full documentation of the options.<a href="#fnref2" class="footnote-back">↩</a></p></li>
</ol>
</div>
</section>
