---
title: "Vignette: Generate your own ggplot theme gallery"

author: "Martin Chan"
date: "May 8, 2020"
layout: post
tags: vignettes tidyverse r
image: https://media.giphy.com/media/dmypi9dyBfmOQ/giphy.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/header-attrs-2.1.1/header-attrs.js"></script>

<section class="main-content">
<div id="background" class="section level2">
<h2>Background</h2>
<p><img src="https://raw.githubusercontent.com/martinctc/blog/master/images/diy-ggplot-theme.png" /></p>
<p>I’ve always found it a bit of a pain to explore and choose from all the different themes available out there for {ggplot2}.</p>
<p>Yes I know, I know - there are probably tons of websites out there with a ggplot theme gallery which I can Google,<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a> but it’s always more fun if you can create your own. So here’s my attempt to do this, on a lockdown Bank Holiday afternoon.</p>
</div>
<div id="diy-ggplot-theme-gallery" class="section level2">
<h2>DIY ggplot theme gallery 📊</h2>
<div id="start-with-a-list-of-plots-and-a-list-of-themes" class="section level3">
<h3>1. Start with a list of plots and a list of themes</h3>
<p>The outcome I want to achieve from this is to create something that would make it easier to decide which ggplot theme to pick for the visualisation at hand. The solution doesn’t need to be fancy: it would be helpful enough to generate all the combinations of plot types X themes, so I can browse through them and get inspirations more easily.</p>
<p>I took a leaf out of <a href="https://www.shanelynn.ie/themes-and-colours-for-r-ggplots-with-ggthemr/">Shayne Lynn’s book/blog</a> and created a couple of “base plots” using <code>iris</code> (yes, boring, but it works). I did these for four types of plots:</p>
<ol style="list-style-type: decimal">
<li>scatter plot</li>
<li>bar plot</li>
<li>box plot</li>
<li>density plot</li>
</ol>
<p>I then assigned these four plots into a list object called <code>plot_list</code>, and converted them into a tibble (<code>plot_base</code>) that I could use for joining afterwards.</p>
<p>This step is then repeated for themes, where I virtually punched in all the existing themes in {ggplot2} and {ggthemes} into a named list (<code>theme_list</code>), and also create a tibble (<code>theme_base</code>). You can make this list as long and exhaustive as you want, but for this example I didn’t want to go into overkill.</p>
<p>You’ll see that I’ve made the names quite elaborate in terms of specifying the package source. The reason for this is because these names will be used afterwards in the plot output, and it will be helpful for identifying the function for generating the theme in the gallery.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="co">#### Load packages ####</span></span>
<span id="cb1-2"><a href="#cb1-2"></a><span class="kw">library</span>(tidyverse)</span>
<span id="cb1-3"><a href="#cb1-3"></a><span class="kw">library</span>(ggthemes) <span class="co"># Optional - only for testing additional themes</span></span>
<span id="cb1-4"><a href="#cb1-4"></a></span>
<span id="cb1-5"><a href="#cb1-5"></a></span>
<span id="cb1-6"><a href="#cb1-6"></a><span class="co">#### Create base plots ####</span></span>
<span id="cb1-7"><a href="#cb1-7"></a><span class="co">## scatter plot</span></span>
<span id="cb1-8"><a href="#cb1-8"></a>point_plot &lt;-</span>
<span id="cb1-9"><a href="#cb1-9"></a><span class="st">  </span><span class="kw">ggplot</span>(iris, <span class="kw">aes</span>(<span class="dt">x=</span><span class="kw">jitter</span>(Sepal.Width),</span>
<span id="cb1-10"><a href="#cb1-10"></a>                   <span class="dt">y=</span><span class="kw">jitter</span>(Sepal.Length),</span>
<span id="cb1-11"><a href="#cb1-11"></a>                   <span class="dt">col=</span>Species)) <span class="op">+</span></span>
<span id="cb1-12"><a href="#cb1-12"></a><span class="st">  </span><span class="kw">geom_point</span>() <span class="op">+</span></span>
<span id="cb1-13"><a href="#cb1-13"></a><span class="st">  </span><span class="kw">labs</span>(<span class="dt">x=</span><span class="st">&quot;Sepal Width (cm)&quot;</span>,</span>
<span id="cb1-14"><a href="#cb1-14"></a>       <span class="dt">y=</span><span class="st">&quot;Sepal Length (cm)&quot;</span>,</span>
<span id="cb1-15"><a href="#cb1-15"></a>       <span class="dt">col=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-16"><a href="#cb1-16"></a>       <span class="dt">title=</span><span class="st">&quot;Iris Dataset - Scatter plot&quot;</span>)</span>
<span id="cb1-17"><a href="#cb1-17"></a></span>
<span id="cb1-18"><a href="#cb1-18"></a><span class="co">## bar plot</span></span>
<span id="cb1-19"><a href="#cb1-19"></a>bar_plot &lt;-</span>
<span id="cb1-20"><a href="#cb1-20"></a><span class="st">  </span>iris <span class="op">%&gt;%</span></span>
<span id="cb1-21"><a href="#cb1-21"></a><span class="st">  </span><span class="kw">group_by</span>(Species) <span class="op">%&gt;%</span></span>
<span id="cb1-22"><a href="#cb1-22"></a><span class="st">  </span><span class="kw">summarise</span>(<span class="dt">Sepal.Width =</span> <span class="kw">mean</span>(Sepal.Width)) <span class="op">%&gt;%</span></span>
<span id="cb1-23"><a href="#cb1-23"></a><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x=</span>Species, <span class="dt">y=</span>Sepal.Width, <span class="dt">fill=</span>Species)) <span class="op">+</span></span>
<span id="cb1-24"><a href="#cb1-24"></a><span class="st">  </span><span class="kw">geom_col</span>() <span class="op">+</span></span>
<span id="cb1-25"><a href="#cb1-25"></a><span class="st">  </span><span class="kw">labs</span>(<span class="dt">x=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-26"><a href="#cb1-26"></a>       <span class="dt">y=</span><span class="st">&quot;Mean Sepal Width (cm)&quot;</span>,</span>
<span id="cb1-27"><a href="#cb1-27"></a>       <span class="dt">fill=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-28"><a href="#cb1-28"></a>       <span class="dt">title=</span><span class="st">&quot;Iris Dataset - Bar plot&quot;</span>)</span>
<span id="cb1-29"><a href="#cb1-29"></a></span>
<span id="cb1-30"><a href="#cb1-30"></a><span class="co">## box plot</span></span>
<span id="cb1-31"><a href="#cb1-31"></a>box_plot &lt;-<span class="st"> </span><span class="kw">ggplot</span>(iris,</span>
<span id="cb1-32"><a href="#cb1-32"></a>                   <span class="kw">aes</span>(<span class="dt">x=</span>Species,</span>
<span id="cb1-33"><a href="#cb1-33"></a>                       <span class="dt">y=</span>Sepal.Width,</span>
<span id="cb1-34"><a href="#cb1-34"></a>                       <span class="dt">fill=</span>Species)) <span class="op">+</span></span>
<span id="cb1-35"><a href="#cb1-35"></a><span class="st">  </span><span class="kw">geom_boxplot</span>() <span class="op">+</span></span>
<span id="cb1-36"><a href="#cb1-36"></a><span class="st">  </span><span class="kw">labs</span>(<span class="dt">x=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-37"><a href="#cb1-37"></a>       <span class="dt">y=</span><span class="st">&quot;Sepal Width (cm)&quot;</span>,</span>
<span id="cb1-38"><a href="#cb1-38"></a>       <span class="dt">fill=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-39"><a href="#cb1-39"></a>       <span class="dt">title=</span><span class="st">&quot;Iris Dataset - Box plot&quot;</span>)</span>
<span id="cb1-40"><a href="#cb1-40"></a></span>
<span id="cb1-41"><a href="#cb1-41"></a><span class="co">## density plot</span></span>
<span id="cb1-42"><a href="#cb1-42"></a>density_plot &lt;-</span>
<span id="cb1-43"><a href="#cb1-43"></a><span class="st">  </span>iris <span class="op">%&gt;%</span></span>
<span id="cb1-44"><a href="#cb1-44"></a><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> Sepal.Length, <span class="dt">fill =</span> Species)) <span class="op">+</span></span>
<span id="cb1-45"><a href="#cb1-45"></a><span class="st">  </span><span class="kw">geom_density</span>() <span class="op">+</span></span>
<span id="cb1-46"><a href="#cb1-46"></a><span class="st">  </span><span class="kw">facet_wrap</span>(.<span class="op">~</span>Species) <span class="op">+</span></span>
<span id="cb1-47"><a href="#cb1-47"></a><span class="st">  </span><span class="kw">labs</span>(<span class="dt">x=</span><span class="st">&quot;Sepal Length (cm)&quot;</span>,</span>
<span id="cb1-48"><a href="#cb1-48"></a>       <span class="dt">y=</span><span class="st">&quot;Density&quot;</span>,</span>
<span id="cb1-49"><a href="#cb1-49"></a>       <span class="dt">fill=</span><span class="st">&quot;Species&quot;</span>,</span>
<span id="cb1-50"><a href="#cb1-50"></a>       <span class="dt">title=</span><span class="st">&quot;Iris Dataset - Density plot&quot;</span>)</span>
<span id="cb1-51"><a href="#cb1-51"></a></span>
<span id="cb1-52"><a href="#cb1-52"></a><span class="co">#### Create iteration table ####</span></span>
<span id="cb1-53"><a href="#cb1-53"></a><span class="co">## Put all base plots in a list</span></span>
<span id="cb1-54"><a href="#cb1-54"></a>plot_list &lt;-</span>
<span id="cb1-55"><a href="#cb1-55"></a><span class="st">  </span><span class="kw">list</span>(<span class="st">&quot;bar plot&quot;</span> =<span class="st"> </span>bar_plot,</span>
<span id="cb1-56"><a href="#cb1-56"></a>       <span class="st">&quot;box plot&quot;</span> =<span class="st"> </span>box_plot,</span>
<span id="cb1-57"><a href="#cb1-57"></a>       <span class="st">&quot;scatter plot&quot;</span> =<span class="st"> </span>point_plot,</span>
<span id="cb1-58"><a href="#cb1-58"></a>       <span class="st">&quot;density plot&quot;</span> =<span class="st"> </span>density_plot)</span>
<span id="cb1-59"><a href="#cb1-59"></a></span>
<span id="cb1-60"><a href="#cb1-60"></a><span class="co">## Convert list into a tibble</span></span>
<span id="cb1-61"><a href="#cb1-61"></a>plot_base &lt;-</span>
<span id="cb1-62"><a href="#cb1-62"></a><span class="st">  </span><span class="kw">tibble</span>(<span class="dt">plot =</span> plot_list,</span>
<span id="cb1-63"><a href="#cb1-63"></a>         <span class="dt">plot_names =</span> <span class="kw">names</span>(plot_list))</span>
<span id="cb1-64"><a href="#cb1-64"></a></span>
<span id="cb1-65"><a href="#cb1-65"></a><span class="co">## Put all themes to test in a named list</span></span>
<span id="cb1-66"><a href="#cb1-66"></a><span class="co">## names will be fed into subtitles</span></span>
<span id="cb1-67"><a href="#cb1-67"></a>theme_list &lt;-</span>
<span id="cb1-68"><a href="#cb1-68"></a><span class="st">  </span><span class="kw">list</span>(<span class="st">&quot;ggplot2::theme_minimal()&quot;</span> =<span class="st"> </span><span class="kw">theme_minimal</span>(),</span>
<span id="cb1-69"><a href="#cb1-69"></a>       <span class="st">&quot;ggplot2::theme_classic()&quot;</span> =<span class="st"> </span><span class="kw">theme_classic</span>(),</span>
<span id="cb1-70"><a href="#cb1-70"></a>       <span class="st">&quot;ggplot2::theme_bw()&quot;</span> =<span class="st"> </span><span class="kw">theme_bw</span>(),</span>
<span id="cb1-71"><a href="#cb1-71"></a>       <span class="st">&quot;ggplot2::theme_gray()&quot;</span> =<span class="st"> </span><span class="kw">theme_gray</span>(),</span>
<span id="cb1-72"><a href="#cb1-72"></a>       <span class="st">&quot;ggplot2::theme_linedraw()&quot;</span> =<span class="st"> </span><span class="kw">theme_linedraw</span>(),</span>
<span id="cb1-73"><a href="#cb1-73"></a>       <span class="st">&quot;ggplot2::theme_light()&quot;</span> =<span class="st"> </span><span class="kw">theme_light</span>(),</span>
<span id="cb1-74"><a href="#cb1-74"></a>       <span class="st">&quot;ggplot2::theme_dark()&quot;</span> =<span class="st"> </span><span class="kw">theme_dark</span>(),</span>
<span id="cb1-75"><a href="#cb1-75"></a>       <span class="st">&quot;ggthemes::theme_economist()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_economist</span>(),</span>
<span id="cb1-76"><a href="#cb1-76"></a>       <span class="st">&quot;ggthemes::theme_economist_white()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_economist_white</span>(),</span>
<span id="cb1-77"><a href="#cb1-77"></a>       <span class="st">&quot;ggthemes::theme_calc()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_calc</span>(),</span>
<span id="cb1-78"><a href="#cb1-78"></a>       <span class="st">&quot;ggthemes::theme_clean()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_clean</span>(),</span>
<span id="cb1-79"><a href="#cb1-79"></a>       <span class="st">&quot;ggthemes::theme_excel()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_excel</span>(),</span>
<span id="cb1-80"><a href="#cb1-80"></a>       <span class="st">&quot;ggthemes::theme_excel_new()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_excel_new</span>(),</span>
<span id="cb1-81"><a href="#cb1-81"></a>       <span class="st">&quot;ggthemes::theme_few()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_few</span>(),</span>
<span id="cb1-82"><a href="#cb1-82"></a>       <span class="st">&quot;ggthemes::theme_fivethirtyeight()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_fivethirtyeight</span>(),</span>
<span id="cb1-83"><a href="#cb1-83"></a>       <span class="st">&quot;ggthemes::theme_foundation()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_foundation</span>(),</span>
<span id="cb1-84"><a href="#cb1-84"></a>       <span class="st">&quot;ggthemes::theme_gdocs()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_gdocs</span>(),</span>
<span id="cb1-85"><a href="#cb1-85"></a>       <span class="st">&quot;ggthemes::theme_hc()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_hc</span>(),</span>
<span id="cb1-86"><a href="#cb1-86"></a>       <span class="st">&quot;ggthemes::theme_igray()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_igray</span>(),</span>
<span id="cb1-87"><a href="#cb1-87"></a>       <span class="st">&quot;ggthemes::theme_solarized()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_solarized</span>(),</span>
<span id="cb1-88"><a href="#cb1-88"></a>       <span class="st">&quot;ggthemes::theme_solarized_2()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_solarized_2</span>(),</span>
<span id="cb1-89"><a href="#cb1-89"></a>       <span class="st">&quot;ggthemes::theme_solid()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_solid</span>(),</span>
<span id="cb1-90"><a href="#cb1-90"></a>       <span class="st">&quot;ggthemes::theme_stata()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_stata</span>(),</span>
<span id="cb1-91"><a href="#cb1-91"></a>       <span class="st">&quot;ggthemes::theme_tufte()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_tufte</span>(),</span>
<span id="cb1-92"><a href="#cb1-92"></a>       <span class="st">&quot;ggthemes::theme_wsj()&quot;</span> =<span class="st"> </span>ggthemes<span class="op">::</span><span class="kw">theme_wsj</span>())</span>
<span id="cb1-93"><a href="#cb1-93"></a></span>
<span id="cb1-94"><a href="#cb1-94"></a><span class="co">## Convert list into a tibble</span></span>
<span id="cb1-95"><a href="#cb1-95"></a>theme_base &lt;-</span>
<span id="cb1-96"><a href="#cb1-96"></a><span class="st">  </span><span class="kw">tibble</span>(<span class="dt">theme =</span> theme_list,</span>
<span id="cb1-97"><a href="#cb1-97"></a>         <span class="dt">theme_names =</span> <span class="kw">names</span>(theme_list))</span>
<span id="cb1-98"><a href="#cb1-98"></a></span>
<span id="cb1-99"><a href="#cb1-99"></a>plot_base</span></code></pre></div>
<pre><code>## # A tibble: 4 x 2
##   plot         plot_names  
##   &lt;named list&gt; &lt;chr&gt;       
## 1 &lt;gg&gt;         bar plot    
## 2 &lt;gg&gt;         box plot    
## 3 &lt;gg&gt;         scatter plot
## 4 &lt;gg&gt;         density plot</code></pre>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1"></a>theme_base</span></code></pre></div>
<pre><code>## # A tibble: 25 x 2
##    theme        theme_names                      
##    &lt;named list&gt; &lt;chr&gt;                            
##  1 &lt;theme&gt;      ggplot2::theme_minimal()         
##  2 &lt;theme&gt;      ggplot2::theme_classic()         
##  3 &lt;theme&gt;      ggplot2::theme_bw()              
##  4 &lt;theme&gt;      ggplot2::theme_gray()            
##  5 &lt;theme&gt;      ggplot2::theme_linedraw()        
##  6 &lt;theme&gt;      ggplot2::theme_light()           
##  7 &lt;theme&gt;      ggplot2::theme_dark()            
##  8 &lt;theme&gt;      ggthemes::theme_economist()      
##  9 &lt;theme&gt;      ggthemes::theme_economist_white()
## 10 &lt;theme&gt;      ggthemes::theme_calc()           
## # ... with 15 more rows</code></pre>
</div>
<div id="create-an-iteration-table" class="section level3">
<h3>2. Create an iteration table</h3>
<p>The next step is to create what I call an iteration table. Here I use <code>tidyr::expand_grid()</code>, which <strong>creates a tibble from all combinations of inputs</strong>. Actually you can use either <code>tidyr::expand_grid()</code> or the base function <code>expand.grid()</code>, but I like the fact that the former returns a tibble rather than a data frame.</p>
<p>The output is <code>all_combos</code>, which is a two column tibble with all combinations of <code>theme_names</code> and <code>plot_names</code>, as character vectors. I then use <code>left_join()</code> twice to bring in the themes and the base plots:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1"></a><span class="co">## Create an iteration data frame</span></span>
<span id="cb5-2"><a href="#cb5-2"></a><span class="co">## Use `expand_grid()` to generate all combinations</span></span>
<span id="cb5-3"><a href="#cb5-3"></a><span class="co">## of themes and plots</span></span>
<span id="cb5-4"><a href="#cb5-4"></a></span>
<span id="cb5-5"><a href="#cb5-5"></a>all_combos &lt;-</span>
<span id="cb5-6"><a href="#cb5-6"></a><span class="st">  </span><span class="kw">expand_grid</span>(<span class="dt">plot_names =</span> plot_base<span class="op">$</span>plot_names,</span>
<span id="cb5-7"><a href="#cb5-7"></a>              <span class="dt">theme_names =</span> theme_base<span class="op">$</span>theme_names)</span>
<span id="cb5-8"><a href="#cb5-8"></a>  </span>
<span id="cb5-9"><a href="#cb5-9"></a>iter_df &lt;-</span>
<span id="cb5-10"><a href="#cb5-10"></a><span class="st">  </span>all_combos <span class="op">%&gt;%</span></span>
<span id="cb5-11"><a href="#cb5-11"></a><span class="st">  </span><span class="kw">left_join</span>(plot_base, <span class="dt">by =</span> <span class="st">&quot;plot_names&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-12"><a href="#cb5-12"></a><span class="st">  </span><span class="kw">left_join</span>(theme_base, <span class="dt">by =</span> <span class="st">&quot;theme_names&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb5-13"><a href="#cb5-13"></a><span class="st">  </span><span class="kw">select</span>(theme_names, theme, plot_names, plot) <span class="co"># Reorder columns</span></span>
<span id="cb5-14"><a href="#cb5-14"></a></span>
<span id="cb5-15"><a href="#cb5-15"></a>iter_df</span></code></pre></div>
<pre><code>## # A tibble: 100 x 4
##    theme_names                       theme   plot_names plot  
##    &lt;chr&gt;                             &lt;list&gt;  &lt;chr&gt;      &lt;list&gt;
##  1 ggplot2::theme_minimal()          &lt;theme&gt; bar plot   &lt;gg&gt;  
##  2 ggplot2::theme_classic()          &lt;theme&gt; bar plot   &lt;gg&gt;  
##  3 ggplot2::theme_bw()               &lt;theme&gt; bar plot   &lt;gg&gt;  
##  4 ggplot2::theme_gray()             &lt;theme&gt; bar plot   &lt;gg&gt;  
##  5 ggplot2::theme_linedraw()         &lt;theme&gt; bar plot   &lt;gg&gt;  
##  6 ggplot2::theme_light()            &lt;theme&gt; bar plot   &lt;gg&gt;  
##  7 ggplot2::theme_dark()             &lt;theme&gt; bar plot   &lt;gg&gt;  
##  8 ggthemes::theme_economist()       &lt;theme&gt; bar plot   &lt;gg&gt;  
##  9 ggthemes::theme_economist_white() &lt;theme&gt; bar plot   &lt;gg&gt;  
## 10 ggthemes::theme_calc()            &lt;theme&gt; bar plot   &lt;gg&gt;  
## # ... with 90 more rows</code></pre>
</div>
<div id="run-your-ggplot-gallery" class="section level3">
<h3>3. Run your ggplot gallery!</h3>
<p>The final step is to create the ggplot “gallery”.</p>
<p>I used <code>purrr::pmap()</code> on <code>iter_df</code>, which applies a function to the data frame, using the values in each column as inputs to the arguments of the function. You will see that:</p>
<ul>
<li><code>iter_label</code> is ultimately used as the names for the list of plots (<code>plot_gallery</code>).</li>
<li><code>label</code> within the function is used for populating the subtitles of the plots</li>
<li><code>output_plot</code> is the plot that is created within the function</li>
</ul>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1"></a><span class="co">#### Run plots ####</span></span>
<span id="cb7-2"><a href="#cb7-2"></a><span class="co">## Use `pmap()` to run all the plots-theme combinations</span></span>
<span id="cb7-3"><a href="#cb7-3"></a></span>
<span id="cb7-4"><a href="#cb7-4"></a><span class="co">## Create labels to be used as names for `plot_gallery`</span></span>
<span id="cb7-5"><a href="#cb7-5"></a>iter_label &lt;-</span>
<span id="cb7-6"><a href="#cb7-6"></a><span class="st">  </span><span class="kw">paste0</span>(<span class="st">&quot;Theme: &quot;</span>,</span>
<span id="cb7-7"><a href="#cb7-7"></a>         iter_df<span class="op">$</span>theme_names,</span>
<span id="cb7-8"><a href="#cb7-8"></a>         <span class="st">&quot;; Plot type: &quot;</span>,</span>
<span id="cb7-9"><a href="#cb7-9"></a>         iter_df<span class="op">$</span>plot_names)</span>
<span id="cb7-10"><a href="#cb7-10"></a></span>
<span id="cb7-11"><a href="#cb7-11"></a><span class="co">## Create a list of plots</span></span>
<span id="cb7-12"><a href="#cb7-12"></a>plot_gallery &lt;-</span>
<span id="cb7-13"><a href="#cb7-13"></a><span class="st">  </span>iter_df <span class="op">%&gt;%</span></span>
<span id="cb7-14"><a href="#cb7-14"></a><span class="st">  </span><span class="kw">pmap</span>(<span class="cf">function</span>(theme_names, theme, plot_names, plot){</span>
<span id="cb7-15"><a href="#cb7-15"></a>    </span>
<span id="cb7-16"><a href="#cb7-16"></a>    label &lt;-<span class="st"> </span></span>
<span id="cb7-17"><a href="#cb7-17"></a><span class="st">      </span><span class="kw">paste0</span>(<span class="st">&quot;Theme: &quot;</span>,</span>
<span id="cb7-18"><a href="#cb7-18"></a>             theme_names,</span>
<span id="cb7-19"><a href="#cb7-19"></a>             <span class="st">&quot;</span><span class="ch">\n</span><span class="st">Plot type: &quot;</span>,</span>
<span id="cb7-20"><a href="#cb7-20"></a>             plot_names)</span>
<span id="cb7-21"><a href="#cb7-21"></a></span>
<span id="cb7-22"><a href="#cb7-22"></a>    output_plot &lt;-</span>
<span id="cb7-23"><a href="#cb7-23"></a><span class="st">      </span>plot <span class="op">+</span></span>
<span id="cb7-24"><a href="#cb7-24"></a><span class="st">      </span>theme <span class="op">+</span></span>
<span id="cb7-25"><a href="#cb7-25"></a><span class="st">      </span><span class="kw">labs</span>(<span class="dt">subtitle =</span> label)</span>
<span id="cb7-26"><a href="#cb7-26"></a>    </span>
<span id="cb7-27"><a href="#cb7-27"></a>    <span class="kw">return</span>(output_plot)</span>
<span id="cb7-28"><a href="#cb7-28"></a>  }) <span class="op">%&gt;%</span></span>
<span id="cb7-29"><a href="#cb7-29"></a><span class="st">  </span><span class="kw">set_names</span>(iter_label)</span>
<span id="cb7-30"><a href="#cb7-30"></a></span>
<span id="cb7-31"><a href="#cb7-31"></a></span>
<span id="cb7-32"><a href="#cb7-32"></a>plot_gallery</span></code></pre></div>
<pre><code>## $`Theme: ggplot2::theme_minimal(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-1.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_classic(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-2.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_bw(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-3.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_gray(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-4.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_linedraw(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-5.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_light(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-6.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_dark(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-7.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-8.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist_white(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-9.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_calc(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-10.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_clean(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-11.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-12.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel_new(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-13.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_few(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-14.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_fivethirtyeight(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-15.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_foundation(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-16.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_gdocs(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-17.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_hc(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-18.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_igray(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-19.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-20.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized_2(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-21.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solid(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-22.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_stata(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-23.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_tufte(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-24.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_wsj(); Plot type: bar plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-25.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_minimal(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-26.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_classic(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-27.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_bw(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-28.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_gray(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-29.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_linedraw(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-30.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_light(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-31.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_dark(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-32.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-33.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist_white(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-34.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_calc(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-35.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_clean(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-36.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-37.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel_new(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-38.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_few(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-39.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_fivethirtyeight(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-40.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_foundation(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-41.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_gdocs(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-42.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_hc(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-43.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_igray(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-44.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-45.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized_2(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-46.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solid(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-47.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_stata(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-48.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_tufte(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-49.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_wsj(); Plot type: box plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-50.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_minimal(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-51.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_classic(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-52.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_bw(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-53.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_gray(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-54.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_linedraw(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-55.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_light(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-56.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_dark(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-57.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-58.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist_white(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-59.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_calc(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-60.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_clean(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-61.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-62.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel_new(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-63.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_few(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-64.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_fivethirtyeight(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-65.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_foundation(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-66.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_gdocs(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-67.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_hc(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-68.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_igray(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-69.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-70.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized_2(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-71.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solid(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-72.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_stata(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-73.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_tufte(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-74.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_wsj(); Plot type: scatter plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-75.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_minimal(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-76.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_classic(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-77.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_bw(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-78.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_gray(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-79.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_linedraw(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-80.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_light(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-81.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggplot2::theme_dark(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-82.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-83.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_economist_white(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-84.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_calc(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-85.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_clean(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-86.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-87.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_excel_new(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-88.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_few(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-89.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_fivethirtyeight(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-90.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_foundation(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-91.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_gdocs(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-92.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_hc(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-93.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_igray(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-94.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-95.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solarized_2(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-96.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_solid(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-97.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_stata(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-98.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_tufte(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-99.png" /><!-- --></p>
<pre><code>## 
## $`Theme: ggthemes::theme_wsj(); Plot type: density plot`</code></pre>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/generate-your-own-ggplot-gallery_20200508_files/figure-html/unnamed-chunk-4-100.png" /><!-- --></p>
</div>
<div id="end-notes" class="section level3">
<h3>End Notes</h3>
<p>And here it is! That didn’t take that many lines of code, but you can already generate a great number of plots with <code>expand_grid()</code> and <code>pmap()</code>.</p>
<p>I should also caveat that this is by no means a “pretty” gallery; it’s very much a minimal implementation, but is good enough for my own consumption.</p>
</div>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>See <a href="https://ggplot2.tidyverse.org/reference/ggtheme.html" class="uri">https://ggplot2.tidyverse.org/reference/ggtheme.html</a> and <a href="https://cmdlinetips.com/2019/10/8-ggplot2-themes/" class="uri">https://cmdlinetips.com/2019/10/8-ggplot2-themes/</a> for instance.<a href="#fnref1" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
