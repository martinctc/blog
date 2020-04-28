---
title: "Data cleaning with Kamehamehas in R"

author: "Martin Chan"
date: "April 11, 2020"
layout: post
tags: learning-r vignettes tidyverse
image: https://raw.githubusercontent.com/martinctc/blog/master/images/kamehameha.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/strongest-kamehameha_20200223_files/header-attrs-2.1.1/header-attrs.js"></script>

<section class="main-content">
<div id="background" class="section level2">
<h2>Background</h2>
<p>Given present circumstances in in the world, I thought it might be nice to write a post on a lighter subject.</p>
<p>Recently, I came across an interesting Kaggle dataset that features <a href="https://www.kaggle.com/shiddharthsaran/dragon-ball-dataset">the power levels of Dragon Ball characters at different points in the franchise</a>. Whilst the dataset itself is quite simple with only four columns (<code>Character</code>, <code>Power_Level</code>, <code>Saga_or_Movie</code>, <code>Dragon_Ball_Series</code>), I noticed that you do need to do a fair amount of data and string manipulation before you can perform any meaningful data analysis with it. Therefore, if you’re a fan of Dragon Ball and interested in learning about string manipulation in R, this post is definitely for you!</p>
<div class="figure">
<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/kamehameha.gif" alt="" />
<p class="caption">The Kamehameha - image from Giphy</p>
</div>
<p>For those who aren’t as interested in Dragon Ball but still interested in general R tricks, please do read ahead anyway - you won’t need to understand the references to know what’s going on with the code. But you have been warned for spoilers! 😂</p>
<p>Functions or techniques that are covered in this post:</p>
<ul>
<li>Basic regular expression (regex) matching</li>
<li><code>stringr::str_detect()</code></li>
<li><code>stringr::str_remove_all()</code> or <code>stringr::str_remove()</code></li>
<li><code>dplyr::anti_join()</code></li>
<li>Example of ‘dark mode’ ggplot in themes</li>
</ul>
</div>
<div id="getting-started" class="section level2">
<h2>Getting started</h2>
<p>You can download the dataset from <a href="https://www.kaggle.com/shiddharthsaran/dragon-ball-dataset">Kaggle</a>, which you’ll need to register an account in order to do so. I would highly recommend doing so if you still haven’t, since they’ve got tons of datasets available on the website which you can practise on.</p>
<p>The next thing I’ll do is to set up my R working directory <a href="https://martinctc.github.io/blog/rstudio-projects-and-working-directories-a-beginner%27s-guide/">in this style</a>, and ensure that the dataset is saved in the <em>datasets</em> subfolder. I’ll use the {here} workflow for this example, which is generally good practice as <code>here::here</code> implicitly sets the path root to the path to the top-level of they current project.</p>
<p>Let’s load our packages and explore the data using <code>glimpse()</code>:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1"></a><span class="kw">library</span>(tidyverse)</span>
<span id="cb1-2"><a href="#cb1-2"></a><span class="kw">library</span>(here)</span>
<span id="cb1-3"><a href="#cb1-3"></a></span>
<span id="cb1-4"><a href="#cb1-4"></a>dball_data &lt;-<span class="st"> </span><span class="kw">read_csv</span>(<span class="kw">here</span>(<span class="st">&quot;datasets&quot;</span>, <span class="st">&quot;Dragon_Ball_Data_Set.csv&quot;</span>))</span>
<span id="cb1-5"><a href="#cb1-5"></a></span>
<span id="cb1-6"><a href="#cb1-6"></a>dball_data <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">glimpse</span>()</span></code></pre></div>
<pre><code>## Observations: 1,244
## Variables: 4
## $ Character          &lt;chr&gt; &quot;Goku&quot;, &quot;Bulma&quot;, &quot;Bear Thief&quot;, &quot;Master Roshi&quot;, &quot;...
## $ Power_Level        &lt;chr&gt; &quot;10&quot;, &quot;1.5&quot;, &quot;7&quot;, &quot;30&quot;, &quot;5&quot;, &quot;8.5&quot;, &quot;4&quot;, &quot;8&quot;, &quot;2...
## $ Saga_or_Movie      &lt;chr&gt; &quot;Emperor Pilaf Saga&quot;, &quot;Emperor Pilaf Saga&quot;, &quot;Emp...
## $ Dragon_Ball_Series &lt;chr&gt; &quot;Dragon Ball&quot;, &quot;Dragon Ball&quot;, &quot;Dragon Ball&quot;, &quot;Dr...</code></pre>
<p>…and also <code>tail()</code> to view the last five rows of the data, just so we get a more comprehensive picture of what some of the other observations in the data look like:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1"></a>dball_data <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">tail</span>()</span></code></pre></div>
<pre><code>## # A tibble: 6 x 4
##   Character              Power_Level       Saga_or_Movie       Dragon_Ball_Seri~
##   &lt;chr&gt;                  &lt;chr&gt;             &lt;chr&gt;               &lt;chr&gt;            
## 1 Goku (base with SSJG ~ 448,000,000,000   Movie 14: Battle o~ Dragon Ball Z    
## 2 Goku (MSSJ with SSJG&#39;~ 22,400,000,000,0~ Movie 14: Battle o~ Dragon Ball Z    
## 3 Goku (SSJG)            224,000,000,000,~ Movie 14: Battle o~ Dragon Ball Z    
## 4 Goku                   44,800,000,000    Movie 14: Battle o~ Dragon Ball Z    
## 5 Beerus (full power, n~ 896,000,000,000,~ Movie 14: Battle o~ Dragon Ball Z    
## 6 Whis (full power, nev~ 4,480,000,000,00~ Movie 14: Battle o~ Dragon Ball Z</code></pre>
</div>
<div id="who-does-the-strongest-kamehameha" class="section level2">
<h2>Who does the strongest Kamehameha? 🔥</h2>
<p>In the Dragon Ball series, there is an energy attack called <em>Kamehameha</em>, which is a signature (and perhaps the most well recognised) move by the main character <strong>Goku</strong>. This move is however not unique to him, and has also been used by other characters in the series, including his son <strong>Gohan</strong> and his master <strong>Muten Roshi</strong>.</p>
<div class="figure">
<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/goku-and-roshi.gif" alt="" />
<p class="caption">Goku and Muten Roshi - image from Giphy</p>
</div>
<p>As you’ll see, this dataset includes observations which detail the power level of the notable occasions when this attack was used. Our task here is get some understanding about this attack move from the data, and see if we can figure out whose kamehameha is actually the strongest out of all the characters.</p>
<div id="data-cleaning" class="section level3">
<h3>Data cleaning</h3>
<p>Here, we use regex (regular expression) string matching to filter on the <code>Character</code> column. The <code>str_detect()</code> function from the {stringr} package detects whether a pattern or expression exists in a string, and returns a logical value of either <code>TRUE</code> or <code>FALSE</code> (which is what <code>dplyr::filter()</code> takes in the second argument). I also used the <code>stringr::regex()</code> function and set the <code>ignore_case</code> argument to <code>TRUE</code>, which makes the filter case-insensitive, such that cases of ‘Kame’ and ‘kAMe’ are also picked up if they do exist.</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1"></a>dball_data <span class="op">%&gt;%</span></span>
<span id="cb5-2"><a href="#cb5-2"></a><span class="st">  </span><span class="kw">filter</span>(<span class="kw">str_detect</span>(Character, <span class="kw">regex</span>(<span class="st">&quot;kameha&quot;</span>, <span class="dt">ignore_case =</span> <span class="ot">TRUE</span>))) -&gt;<span class="st"> </span>dball_data_<span class="dv">1</span></span>
<span id="cb5-3"><a href="#cb5-3"></a></span>
<span id="cb5-4"><a href="#cb5-4"></a>dball_data_<span class="dv">1</span> <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">head</span>()</span></code></pre></div>
<pre><code>## # A tibble: 6 x 4
##   Character                     Power_Level Saga_or_Movie      Dragon_Ball_Seri~
##   &lt;chr&gt;                         &lt;chr&gt;       &lt;chr&gt;              &lt;chr&gt;            
## 1 Master Roshi&#39;s Max Power Kam~ 180         Emperor Pilaf Saga Dragon Ball      
## 2 Goku&#39;s Kamehameha             12          Emperor Pilaf Saga Dragon Ball      
## 3 Jackie Chun&#39;s Max power Kame~ 330         Tournament Saga    Dragon Ball      
## 4 Goku&#39;s Kamehameha             90          Red Ribbon Army S~ Dragon Ball      
## 5 Goku&#39;s Kamehameha             90          Red Ribbon Army S~ Dragon Ball      
## 6 Goku&#39;s Super Kamehameha       740         Piccolo Jr. Saga   Dragon Ball</code></pre>
<p>If this filter feels convoluted, it’s for a good reason. There is a variation of cases and spellings used in this dataset, which a ‘straightforward’ filter wouldn’t have picked up. So there are two of these:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1"></a>dball_data <span class="op">%&gt;%</span></span>
<span id="cb7-2"><a href="#cb7-2"></a><span class="st">  </span><span class="kw">filter</span>(<span class="kw">str_detect</span>(Character, <span class="st">&quot;Kamehameha&quot;</span>)) -&gt;<span class="st"> </span>dball_data_1b</span>
<span id="cb7-3"><a href="#cb7-3"></a></span>
<span id="cb7-4"><a href="#cb7-4"></a><span class="co">## Show the rows which do not appears on BOTH datasets</span></span>
<span id="cb7-5"><a href="#cb7-5"></a>dball_data_<span class="dv">1</span> <span class="op">%&gt;%</span></span>
<span id="cb7-6"><a href="#cb7-6"></a><span class="st">  </span>dplyr<span class="op">::</span><span class="kw">anti_join</span>(dball_data_1b, <span class="dt">by =</span> <span class="st">&quot;Character&quot;</span>)</span></code></pre></div>
<pre><code>## # A tibble: 2 x 4
##   Character                        Power_Level Saga_or_Movie   Dragon_Ball_Seri~
##   &lt;chr&gt;                            &lt;chr&gt;       &lt;chr&gt;           &lt;chr&gt;            
## 1 Jackie Chun&#39;s Max power Kameham~ 330         Tournament Saga Dragon Ball      
## 2 Android 19 (Goku&#39;s kamehameha a~ 230,000,000 Android Saga    Dragon Ball Z</code></pre>
<p>Before we go any further with any analysis, we’ll also need to do something about <code>Power_Level</code>, as it is currently in the form of character / text, which means we can’t do any meaningful analysis until we convert it to numeric. To do this, we can start with removing the comma separators with <code>stringr::str_remove_all()</code>, and then run <code>as.numeric()</code>.</p>
<p>In ‘real life’, you often get data saved with <em>k</em> and <em>m</em> suffixes for thousands and millions, which will require a bit more cleaning to do - so here, I’m just thankful that all I have to do is to remove some comma separators.</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1"></a>dball_data_<span class="dv">1</span> <span class="op">%&gt;%</span></span>
<span id="cb9-2"><a href="#cb9-2"></a><span class="st">  </span><span class="kw">mutate_at</span>(<span class="st">&quot;Power_Level&quot;</span>, <span class="op">~</span><span class="kw">str_remove_all</span>(., <span class="st">&quot;,&quot;</span>)) <span class="op">%&gt;%</span></span>
<span id="cb9-3"><a href="#cb9-3"></a><span class="st">  </span><span class="kw">mutate_at</span>(<span class="st">&quot;Power_Level&quot;</span>, <span class="op">~</span><span class="kw">as.numeric</span>(.)) -&gt;<span class="st"> </span>dball_data_<span class="dv">2</span></span>
<span id="cb9-4"><a href="#cb9-4"></a></span>
<span id="cb9-5"><a href="#cb9-5"></a>dball_data_<span class="dv">2</span> <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">tail</span>()</span></code></pre></div>
<pre><code>## # A tibble: 6 x 4
##   Character           Power_Level Saga_or_Movie                Dragon_Ball_Seri~
##   &lt;chr&gt;                     &lt;dbl&gt; &lt;chr&gt;                        &lt;chr&gt;            
## 1 Goku&#39;s Super Kame~  25300000000 OVA: Plan to Eradicate the ~ Dragon Ball Z    
## 2 Family Kamehameha  300000000000 Movie 10: Broly- The Second~ Dragon Ball Z    
## 3 Krillin&#39;s Kameham~      8000000 Movie 11: Bio-Broly          Dragon Ball Z    
## 4 Goten&#39;s Kamehameha    950000000 Movie 11: Bio-Broly          Dragon Ball Z    
## 5 Trunk&#39;s Kamehameha    980000000 Movie 11: Bio-Broly          Dragon Ball Z    
## 6 Goten&#39;s Super Kam~   3000000000 Movie 11: Bio-Broly          Dragon Ball Z</code></pre>
<p>Now that we’ve fixed the <code>Power_Level</code> column, the next step is to isolate the information about the characters from the <code>Character</code> column. The reason why we have to do this is because, inconveniently, the column provides information for both the <em>character</em> and <em>the occasion</em> of when the kamehameha is used, which means we won’t be able to easily filter or group the dataset by the characters only.</p>
<p>One way to overcome this problem is to use the apostrophe (or single quote) as a delimiter to extract the characters from the column. Before I do this, I will take another manual step to remove the rows corresponding to absorbed kamehamehas, e.g. <em>Android 19 (Goku’s kamehameha absorbed)</em>, as it refers to the character’s power level <em>after</em> absorbing the attack, rather than the attack itself. (Yes, some characters are able to absorb kamehameha attacks and make themselves stronger..!)</p>
<p>After applying the filter, I use <code>mutate()</code> to create a new column called <code>Character_Single</code>, and then <code>str_remove_all()</code> to remove all the characters that appear after the apostrophe:</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb11-1"><a href="#cb11-1"></a>dball_data_<span class="dv">2</span> <span class="op">%&gt;%</span></span>
<span id="cb11-2"><a href="#cb11-2"></a><span class="st">  </span><span class="kw">filter</span>(<span class="op">!</span><span class="kw">str_detect</span>(Character, <span class="st">&quot;absorbed&quot;</span>)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Remove 2 rows unrelated to kamehameha attacks</span></span>
<span id="cb11-3"><a href="#cb11-3"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">Character_Single =</span> <span class="kw">str_remove_all</span>(Character, <span class="st">&quot;</span><span class="ch">\\</span><span class="st">&#39;.+&quot;</span>)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Remove everything after apostrophe</span></span>
<span id="cb11-4"><a href="#cb11-4"></a><span class="st">  </span><span class="kw">select</span>(Character_Single, <span class="kw">everything</span>()) -&gt;<span class="st"> </span>dball_data_<span class="dv">3</span></span></code></pre></div>
<pre><code>## # A tibble: 10 x 5
##    Character_Single Character       Power_Level Saga_or_Movie   Dragon_Ball_Ser~
##    &lt;chr&gt;            &lt;chr&gt;                 &lt;dbl&gt; &lt;chr&gt;           &lt;chr&gt;           
##  1 Master Roshi     Master Roshi&#39;s~         180 Emperor Pilaf ~ Dragon Ball     
##  2 Goku             Goku&#39;s Kameham~          12 Emperor Pilaf ~ Dragon Ball     
##  3 Jackie Chun      Jackie Chun&#39;s ~         330 Tournament Saga Dragon Ball     
##  4 Goku             Goku&#39;s Kameham~          90 Red Ribbon Arm~ Dragon Ball     
##  5 Goku             Goku&#39;s Kameham~          90 Red Ribbon Arm~ Dragon Ball     
##  6 Goku             Goku&#39;s Super K~         740 Piccolo Jr. Sa~ Dragon Ball     
##  7 Goku             Goku&#39;s Kameham~         950 Saiyan Saga     Dragon Ball Z   
##  8 Goku             Goku&#39;s Kameham~       36000 Saiyan Saga     Dragon Ball Z   
##  9 Goku             Goku&#39;s Kameham~       44000 Saiyan Saga     Dragon Ball Z   
## 10 Goku             Goku&#39;s Angry K~   180000000 Frieza Saga     Dragon Ball Z</code></pre>
<p>Note that the apostrophe is a special character, and therefore it needs to be escaped by adding two forward slashes before it. The dot (<code>.</code>) matches all characters, and <code>+</code> tells R to match the preceding dot to match one or more times. Regex is a very useful thing to learn, and I would highly recommend just reading through the linked references below if you’ve never used regular expressions before.<a href="#fn1" class="footnote-ref" id="fnref1"><sup>1</sup></a></p>
</div>
<div id="analysis" class="section level3">
<h3>Analysis</h3>
<p>Now that we’ve got a clean dataset, what can we find out about the Kamehamehas?</p>
<div class="figure">
<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/kamehameha2.gif" alt="" />
<p class="caption">The Kamehameha - image from Giphy</p>
</div>
<p>My approach is start with calculating the average power levels of Kamehamehas in R, grouped by <code>Character_Single</code>. The resulting table tells us that on average, Goku’s Kamehameha is the most powerful, followed by Gohan:</p>
<div class="sourceCode" id="cb13"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb13-1"><a href="#cb13-1"></a>dball_data_<span class="dv">3</span> <span class="op">%&gt;%</span></span>
<span id="cb13-2"><a href="#cb13-2"></a><span class="st">  </span><span class="kw">group_by</span>(Character_Single) <span class="op">%&gt;%</span></span>
<span id="cb13-3"><a href="#cb13-3"></a><span class="st">  </span><span class="kw">summarise_at</span>(<span class="kw">vars</span>(Power_Level), <span class="op">~</span><span class="kw">mean</span>(.)) <span class="op">%&gt;%</span></span>
<span id="cb13-4"><a href="#cb13-4"></a><span class="st">  </span><span class="kw">arrange</span>(<span class="kw">desc</span>(Power_Level)) -&gt;<span class="st"> </span>kame_data_grouped <span class="co"># Sort by descending</span></span>
<span id="cb13-5"><a href="#cb13-5"></a></span>
<span id="cb13-6"><a href="#cb13-6"></a>kame_data_grouped</span></code></pre></div>
<pre><code>## # A tibble: 11 x 2
##    Character_Single           Power_Level
##    &lt;chr&gt;                            &lt;dbl&gt;
##  1 Goku                           3.46e14
##  2 Gohan                          1.82e12
##  3 Family Kamehameha              3.00e11
##  4 Super Perfect Cell             8.00e10
##  5 Perfect Cell                   3.02e10
##  6 Goten                          1.98e 9
##  7 Trunk                          9.80e 8
##  8 Krillin                        8.00e 6
##  9 Student-Teacher Kamehameha     1.70e 4
## 10 Jackie Chun                    3.30e 2
## 11 Master Roshi                   1.80e 2</code></pre>
<p>However, it’s not helpful to directly visualise this on a bar chart, as the Power Level of the strongest Kamehameha is 175,433 times greater than the median!</p>
<div class="sourceCode" id="cb15"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb15-1"><a href="#cb15-1"></a>kame_data_grouped <span class="op">%&gt;%</span></span>
<span id="cb15-2"><a href="#cb15-2"></a><span class="st">  </span><span class="kw">pull</span>(Power_Level) <span class="op">%&gt;%</span></span>
<span id="cb15-3"><a href="#cb15-3"></a><span class="st">  </span><span class="kw">summary</span>()</span></code></pre></div>
<pre><code>##      Min.   1st Qu.    Median      Mean   3rd Qu.      Max. 
## 1.800e+02 4.008e+06 1.975e+09 3.170e+13 1.900e+11 3.465e+14</code></pre>
<p>A way around this is to log transform the <code>Power_Level</code> variable prior to visualising it, which I’ve saved the data into a new column called <code>Power_Index</code>. Then, we can pipe the data directly into a ggplot chain, and set a dark mode using <code>theme()</code>:</p>
<div class="sourceCode" id="cb17"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb17-1"><a href="#cb17-1"></a>kame_data_grouped <span class="op">%&gt;%</span></span>
<span id="cb17-2"><a href="#cb17-2"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">Power_Index =</span> <span class="kw">log</span>(Power_Level)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Log transform Power Levels</span></span>
<span id="cb17-3"><a href="#cb17-3"></a><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> <span class="kw">reorder</span>(Character_Single, Power_Level),</span>
<span id="cb17-4"><a href="#cb17-4"></a>             <span class="dt">y =</span> Power_Index,</span>
<span id="cb17-5"><a href="#cb17-5"></a>             <span class="dt">fill =</span> Character_Single)) <span class="op">+</span></span>
<span id="cb17-6"><a href="#cb17-6"></a><span class="st">  </span><span class="kw">geom_col</span>() <span class="op">+</span></span>
<span id="cb17-7"><a href="#cb17-7"></a><span class="st">  </span><span class="kw">coord_flip</span>() <span class="op">+</span></span>
<span id="cb17-8"><a href="#cb17-8"></a><span class="st">  </span><span class="kw">scale_fill_brewer</span>(<span class="dt">palette =</span> <span class="st">&quot;Spectral&quot;</span>) <span class="op">+</span></span>
<span id="cb17-9"><a href="#cb17-9"></a><span class="st">  </span><span class="kw">theme_minimal</span>() <span class="op">+</span></span>
<span id="cb17-10"><a href="#cb17-10"></a><span class="st">  </span><span class="kw">geom_text</span>(<span class="kw">aes</span>(<span class="dt">y =</span> Power_Index,</span>
<span id="cb17-11"><a href="#cb17-11"></a>                <span class="dt">label =</span> <span class="kw">round</span>(Power_Index, <span class="dv">1</span>),</span>
<span id="cb17-12"><a href="#cb17-12"></a>                <span class="dt">hjust =</span> <span class="fl">-.2</span>),</span>
<span id="cb17-13"><a href="#cb17-13"></a>            <span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>) <span class="op">+</span></span>
<span id="cb17-14"><a href="#cb17-14"></a><span class="st">  </span><span class="kw">ggtitle</span>(<span class="st">&quot;Power Levels of Kamehamehas&quot;</span>, <span class="dt">subtitle =</span> <span class="st">&quot;By Dragon Ball characters&quot;</span>) <span class="op">+</span></span>
<span id="cb17-15"><a href="#cb17-15"></a><span class="st">  </span><span class="kw">theme</span>(<span class="dt">plot.background =</span> <span class="kw">element_rect</span>(<span class="dt">fill =</span> <span class="st">&quot;grey20&quot;</span>),</span>
<span id="cb17-16"><a href="#cb17-16"></a>        <span class="dt">text =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>),</span>
<span id="cb17-17"><a href="#cb17-17"></a>        <span class="dt">panel.grid =</span> <span class="kw">element_blank</span>(),</span>
<span id="cb17-18"><a href="#cb17-18"></a>        <span class="dt">plot.title =</span> <span class="kw">element_text</span>(<span class="dt">colour=</span><span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">face=</span><span class="st">&quot;bold&quot;</span>, <span class="dt">size=</span><span class="dv">20</span>),</span>
<span id="cb17-19"><a href="#cb17-19"></a>        <span class="dt">axis.line =</span> <span class="kw">element_line</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>),</span>
<span id="cb17-20"><a href="#cb17-20"></a>        <span class="dt">legend.position =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb17-21"><a href="#cb17-21"></a>        <span class="dt">axis.title =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">size =</span> <span class="dv">12</span>),</span>
<span id="cb17-22"><a href="#cb17-22"></a>        <span class="dt">axis.text =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">size =</span> <span class="dv">12</span>)) <span class="op">+</span></span>
<span id="cb17-23"><a href="#cb17-23"></a><span class="st">  </span><span class="kw">ylab</span>(<span class="st">&quot;Power Levels (log transformed)&quot;</span>) <span class="op">+</span></span>
<span id="cb17-24"><a href="#cb17-24"></a><span class="st">  </span><span class="kw">xlab</span>(<span class="st">&quot; &quot;</span>)</span></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/strongest-kamehameha_20200223_files/figure-html/unnamed-chunk-11-1.png" /><!-- --></p>
<p>So as it turns out, the results aren’t too surprising. Goku’s Kamehameha is the strongest of all the characters on average, although it has been referenced several times in the series that his son Gohan’s latent powers are beyond Goku’s.</p>
<p>Also, it is perhaps unsurprising that Master Roshi’s Kamehameha is the least powerful, given a highly powered comparison set of characters. Interestingly, Roshi’s Kamehameha is stronger as ‘Jackie Chun’ than as himself.</p>
<p>We can also see the extent to which Goku’s Kamehameha has grown more powerful across the series. This is available in the column <code>Saga_or_Movie</code>. In the same approach as above, we can do this by grouping the data by <code>Saga_or_Movie</code>, and pipe this into a ggplot bar chart:</p>
<div class="sourceCode" id="cb18"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb18-1"><a href="#cb18-1"></a>dball_data_<span class="dv">3</span> <span class="op">%&gt;%</span></span>
<span id="cb18-2"><a href="#cb18-2"></a><span class="st">  </span><span class="kw">filter</span>(Character_Single <span class="op">==</span><span class="st"> &quot;Goku&quot;</span>) <span class="op">%&gt;%</span></span>
<span id="cb18-3"><a href="#cb18-3"></a><span class="st">  </span><span class="kw">mutate</span>(<span class="dt">Power_Index =</span> <span class="kw">log</span>(Power_Level)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Log transform Power Levels</span></span>
<span id="cb18-4"><a href="#cb18-4"></a><span class="st">  </span><span class="kw">group_by</span>(Saga_or_Movie) <span class="op">%&gt;%</span></span>
<span id="cb18-5"><a href="#cb18-5"></a><span class="st">  </span><span class="kw">summarise</span>(<span class="dt">Power_Index =</span> <span class="kw">mean</span>(Power_Index)) <span class="op">%&gt;%</span></span>
<span id="cb18-6"><a href="#cb18-6"></a><span class="st">  </span><span class="kw">ggplot</span>(<span class="kw">aes</span>(<span class="dt">x =</span> <span class="kw">reorder</span>(Saga_or_Movie, Power_Index),</span>
<span id="cb18-7"><a href="#cb18-7"></a>             <span class="dt">y =</span> Power_Index)) <span class="op">+</span></span>
<span id="cb18-8"><a href="#cb18-8"></a><span class="st">  </span><span class="kw">geom_col</span>(<span class="dt">fill =</span> <span class="st">&quot;#F85B1A&quot;</span>) <span class="op">+</span></span>
<span id="cb18-9"><a href="#cb18-9"></a><span class="st">  </span><span class="kw">theme_minimal</span>() <span class="op">+</span></span>
<span id="cb18-10"><a href="#cb18-10"></a><span class="st">  </span><span class="kw">geom_text</span>(<span class="kw">aes</span>(<span class="dt">y =</span> Power_Index,</span>
<span id="cb18-11"><a href="#cb18-11"></a>                <span class="dt">label =</span> <span class="kw">round</span>(Power_Index, <span class="dv">1</span>),</span>
<span id="cb18-12"><a href="#cb18-12"></a>                <span class="dt">vjust =</span> <span class="fl">-.5</span>),</span>
<span id="cb18-13"><a href="#cb18-13"></a>                <span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>) <span class="op">+</span></span>
<span id="cb18-14"><a href="#cb18-14"></a><span class="st">  </span><span class="kw">ggtitle</span>(<span class="st">&quot;Power Levels of Goku&#39;s Kamehamehas&quot;</span>, <span class="dt">subtitle =</span> <span class="st">&quot;By Saga/Movie&quot;</span>) <span class="op">+</span></span>
<span id="cb18-15"><a href="#cb18-15"></a><span class="st">  </span><span class="kw">scale_y_continuous</span>(<span class="dt">limits =</span> <span class="kw">c</span>(<span class="dv">0</span>, <span class="dv">40</span>)) <span class="op">+</span></span>
<span id="cb18-16"><a href="#cb18-16"></a><span class="st">  </span><span class="kw">theme</span>(<span class="dt">plot.background =</span> <span class="kw">element_rect</span>(<span class="dt">fill =</span> <span class="st">&quot;grey20&quot;</span>),</span>
<span id="cb18-17"><a href="#cb18-17"></a>        <span class="dt">text =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>),</span>
<span id="cb18-18"><a href="#cb18-18"></a>        <span class="dt">panel.grid =</span> <span class="kw">element_blank</span>(),</span>
<span id="cb18-19"><a href="#cb18-19"></a>        <span class="dt">plot.title =</span> <span class="kw">element_text</span>(<span class="dt">colour=</span><span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">face=</span><span class="st">&quot;bold&quot;</span>, <span class="dt">size=</span><span class="dv">20</span>),</span>
<span id="cb18-20"><a href="#cb18-20"></a>        <span class="dt">plot.subtitle =</span> <span class="kw">element_text</span>(<span class="dt">colour=</span><span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">face=</span><span class="st">&quot;bold&quot;</span>, <span class="dt">size=</span><span class="dv">12</span>),</span>
<span id="cb18-21"><a href="#cb18-21"></a>        <span class="dt">axis.line =</span> <span class="kw">element_line</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>),</span>
<span id="cb18-22"><a href="#cb18-22"></a>        <span class="dt">legend.position =</span> <span class="st">&quot;none&quot;</span>,</span>
<span id="cb18-23"><a href="#cb18-23"></a>        <span class="dt">axis.title =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">size =</span> <span class="dv">10</span>),</span>
<span id="cb18-24"><a href="#cb18-24"></a>        <span class="dt">axis.text.y =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">size =</span> <span class="dv">8</span>),</span>
<span id="cb18-25"><a href="#cb18-25"></a>        <span class="dt">axis.text.x =</span> <span class="kw">element_text</span>(<span class="dt">colour =</span> <span class="st">&quot;#FFFFFF&quot;</span>, <span class="dt">size =</span> <span class="dv">8</span>, <span class="dt">angle =</span> <span class="dv">45</span>, <span class="dt">hjust =</span> <span class="dv">1</span>)) <span class="op">+</span></span>
<span id="cb18-26"><a href="#cb18-26"></a><span class="st">  </span><span class="kw">ylab</span>(<span class="st">&quot;Power Levels (log transformed)&quot;</span>) <span class="op">+</span></span>
<span id="cb18-27"><a href="#cb18-27"></a><span class="st">  </span><span class="kw">xlab</span>(<span class="st">&quot; &quot;</span>)</span></code></pre></div>
<p><img src="{{ site.url }}{{ site.baseurl }}/knitr_files/strongest-kamehameha_20200223_files/figure-html/unnamed-chunk-12-1.png" /><!-- --></p>
<p>I don’t have full knowledge of the chronology of the franchise, but I do know that <em>Emperor Pilaf Saga</em>, <em>Red Ribbon Army Saga</em>, and <em>Piccolo Jr. Saga</em> are the earliest story arcs where Goku’s martial arts abilities are still developing. It also appears that if I’d like to witness Goku’s most powerful Kamehameha attack, I should find this in the <em>Baby Saga</em>!</p>
</div>
</div>
<div id="notes" class="section level2">
<h2>Notes</h2>
<p>Hope this was an interesting read for you, and that this tells you something new about R or Dragon Ball.</p>
<p>There is certainly more you can do with this dataset, especially once it is processed into a usable, tidy format.</p>
<p>If you have any related datasets that will help make this analysis more interesting, please let me know!</p>
<p>In the mean time, please stay safe and take care all!</p>
</div>
<div class="footnotes">
<hr />
<ol>
<li id="fn1"><p>See <a href="https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html" class="uri">https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html</a> and <a href="https://stringr.tidyverse.org/articles/regular-expressions.html" class="uri">https://stringr.tidyverse.org/articles/regular-expressions.html</a><a href="#fnref1" class="footnote-back">↩︎</a></p></li>
</ol>
</div>
</section>
