---
title: "Vignette: Write & Read Multiple Excel files with purrr"

author: "Martin Chan"
date: "June 28, 2019"
layout: post
tags: tidyverse vignettes excel rdatatable r
image: http://martinctc.github.io/blog/images/hex-purrr.png
---


<section class="main-content">
<div id="introduction" class="section level2">
<h2>Introduction</h2>
<p>This post will show you how to write and read a list of data tables to and from Excel with <a href="https://purrr.tidyverse.org/"><strong>purrr</strong></a>, the functional programming package 📦 from <strong>tidyverse</strong>. In this example I will also use the packages <strong>readxl</strong> and <strong>writexl</strong> for reading and writing in Excel files, and cover methods for both XLSX and CSV (not strictly Excel, but might as well!) files.</p>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/hex-purrr.png" width="20%" style="float:right; padding:10px" /></p>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/readxl.png" width="20%" style="float:right; padding:10px" /></p>
<p>Whilst the internet is certainly in no shortage of R tutorials on how to read and write Excel files (see <a href="https://stackoverflow.com/questions/32888757/how-can-i-read-multiple-excel-files-into-r">this Stack Overflow thread</a> for example), I think a <strong>purrr</strong> approach still isn’t as well-known or well-documented. I find this approach to be very clean and readable, and certainly more “tidyverse-consistent” than other approaches which rely on <code>lapply()</code> or for loops. My choice of packages 📦 for reading and writing Excel files are <a href="https://readxl.tidyverse.org/">readxl</a> and <a href="https://docs.ropensci.org/writexl/">writexl</a>, where the advantage is that neither of them require external dependencies.</p>
<p>For reading and writing CSV files, I personally have switched back and forth between <strong>readr</strong> and <strong>data.table</strong>, depending on whether I have a need to do a particular analysis in <strong>data.table</strong> (see <a href="https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/">this discussion</a> on why I sometimes use it in favour of <strong>dplyr</strong>). Where applicable in this post, I will point out in places where you can use alternatives from <a href="https://github.com/Rdatatable/data.table/wiki">data.table</a> for fast reading/writing.</p>
<p>For documentation/demonstration purposes, I’ll make the package references (indicated by <code>::</code>) explicit in the functions below, but it’s advisable to remove them in “real life” to avoid code that is overly verbose.</p>
<hr />
</div>
<div id="getting-started" class="section level2">
<h2>Getting Started</h2>
<p>The key functions used in this vignette come from three packages: <strong>purrr</strong>, <strong>readxl</strong>, and <strong>writexl</strong>.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span class="kw">library</span>(tidyverse)
<span class="kw">library</span>(readxl)
<span class="kw">library</span>(writexl)</code></pre></div>
<p>Since <strong>purrr</strong> is part of core <strong>tidyverse</strong>, we can simply run <code>library(tidyverse)</code>. This is also convenient as we’ll also use various functions such as <code>group_split()</code> from <strong>dplyr</strong> and the <code>%&gt;%</code> operator from <strong>magrittr</strong> in the example.</p>
<p>Note that although <strong>readxl</strong> is part of tidyverse, you’ll still need to load it explicitly as it’s not a “core” tidyverse package.</p>
<hr />
</div>
<div id="writing-multiple-excel-files" class="section level2">
<h2>Writing multiple Excel files</h2>
<p>Let us start off with the <strong>iris</strong> dataset that is pre-loaded with R. If you’re not one of us sad people who almost know this dataset by heart, here’s what it looks like:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r">iris <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">head</span>()</code></pre></div>
<pre><code>##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa</code></pre>
<p>The first thing that we want to do is to create multiple datasets, which we can do so by splitting <strong>iris</strong>. I’ll do this by running <code>group_split()</code> on the <strong>Species</strong> column, so that each species of iris has its own dataset. This will return a list of three data frames, one for each unique value in <strong>Species</strong>: <em>setosa</em>, <em>versicolor</em>, and <em>virginica</em>. I’ll assign these three data frames to a list object called <code>list_of_dfs</code>:</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Split: one data frame per Species</span>
iris <span class="op">%&gt;%</span>
<span class="st">  </span>dplyr<span class="op">::</span><span class="kw">group_split</span>(Species) -&gt;<span class="st"> </span>list_of_dfs

list_of_dfs</code></pre></div>
<pre><code>## [[1]]
## # A tibble: 50 x 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
##           &lt;dbl&gt;       &lt;dbl&gt;        &lt;dbl&gt;       &lt;dbl&gt; &lt;fct&gt;  
##  1          5.1         3.5          1.4         0.2 setosa 
##  2          4.9         3            1.4         0.2 setosa 
##  3          4.7         3.2          1.3         0.2 setosa 
##  4          4.6         3.1          1.5         0.2 setosa 
##  5          5           3.6          1.4         0.2 setosa 
##  6          5.4         3.9          1.7         0.4 setosa 
##  7          4.6         3.4          1.4         0.3 setosa 
##  8          5           3.4          1.5         0.2 setosa 
##  9          4.4         2.9          1.4         0.2 setosa 
## 10          4.9         3.1          1.5         0.1 setosa 
## # ... with 40 more rows
## 
## [[2]]
## # A tibble: 50 x 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species   
##           &lt;dbl&gt;       &lt;dbl&gt;        &lt;dbl&gt;       &lt;dbl&gt; &lt;fct&gt;     
##  1          7           3.2          4.7         1.4 versicolor
##  2          6.4         3.2          4.5         1.5 versicolor
##  3          6.9         3.1          4.9         1.5 versicolor
##  4          5.5         2.3          4           1.3 versicolor
##  5          6.5         2.8          4.6         1.5 versicolor
##  6          5.7         2.8          4.5         1.3 versicolor
##  7          6.3         3.3          4.7         1.6 versicolor
##  8          4.9         2.4          3.3         1   versicolor
##  9          6.6         2.9          4.6         1.3 versicolor
## 10          5.2         2.7          3.9         1.4 versicolor
## # ... with 40 more rows
## 
## [[3]]
## # A tibble: 50 x 5
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species  
##           &lt;dbl&gt;       &lt;dbl&gt;        &lt;dbl&gt;       &lt;dbl&gt; &lt;fct&gt;    
##  1          6.3         3.3          6           2.5 virginica
##  2          5.8         2.7          5.1         1.9 virginica
##  3          7.1         3            5.9         2.1 virginica
##  4          6.3         2.9          5.6         1.8 virginica
##  5          6.5         3            5.8         2.2 virginica
##  6          7.6         3            6.6         2.1 virginica
##  7          4.9         2.5          4.5         1.7 virginica
##  8          7.3         2.9          6.3         1.8 virginica
##  9          6.7         2.5          5.8         1.8 virginica
## 10          7.2         3.6          6.1         2.5 virginica
## # ... with 40 more rows</code></pre>
<p>I’ll also use <code>purrr::map()</code> to take the character values (<em>setosa</em>, <em>versicolor</em>, and <em>virginica</em>) from the Species column itself for assigning names to the list. <code>map()</code> transforms an input by applying a function to each element of the input, and then returns a vector the same length as the input. In this immediate example, the input is the <code>list_of_dfs</code> and we apply the function <code>dplyr::pull()</code> to extract the <strong>Species</strong> variable from each data frame. We then repeat this approach to convert <strong>Species</strong> into character type with <code>as.character()</code> and take out a single value with <code>unique()</code>:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Use the value from the &quot;Species&quot; column to provide a name for the list members</span>
list_of_dfs <span class="op">%&gt;%</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="op">~</span><span class="kw">pull</span>(.,Species)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Pull out Species variable</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="op">~</span><span class="kw">as.character</span>(.)) <span class="op">%&gt;%</span><span class="st"> </span><span class="co"># Convert factor to character</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="op">~</span><span class="kw">unique</span>(.)) -&gt;<span class="st"> </span><span class="kw">names</span>(list_of_dfs) <span class="co"># Set this as names for list members</span>

<span class="kw">names</span>(list_of_dfs)</code></pre></div>
<pre><code>## [1] &quot;setosa&quot;     &quot;versicolor&quot; &quot;virginica&quot;</code></pre>
<p>These names will be useful for exporting the data frames into Excel, as they will effectively be our Excel sheet names. You can always manually hard-code the sheet names, but the above approach allows you to do the entire thing dynamically if you need to.</p>
<p>Having set the sheet names, I can then pipe the list of data frames directly into <code>write_xlsx()</code>, where the Excel file name and path is specified in the same <code>path</code> argument:</p>
<div class="sourceCode" id="cb8"><pre class="sourceCode r"><code class="sourceCode r">list_of_dfs <span class="op">%&gt;%</span>
<span class="st">  </span>writexl<span class="op">::</span><span class="kw">write_xlsx</span>(<span class="dt">path =</span> <span class="st">&quot;../datasets/test-excel/test-excel.xlsx&quot;</span>)</code></pre></div>
<div id="writing-multiple-csv-files" class="section level3">
<h3>Writing multiple CSV files</h3>
<p>Exporting the list of data frames into multiple CSV files will take a few more lines of code, but still relatively straightforward. There are three main steps:</p>
<ol style="list-style-type: decimal">
<li><p>Define a function that tells R what the names for each CSV file should be, which I’ve called <code>output_csv()</code> below. The <strong>data</strong> argument will take in a data frame whilst the <strong>names</strong> argument will take in a character string that will form part of the file name for the individual CSV file.</p></li>
<li><p>Create a named list where the names match the arguments of the function you’ve just defined (<strong>data</strong> and <strong>names</strong>), and should contain the objects that you would like to pass through to the function for the respective arguments. In this case, <strong>list_of_dfs</strong> will provide the three data frames, and <strong>names(list_of_dfs)</strong> will provide the names of those three data frames. This is necessary for running <code>pmap()</code>, which in my view is basically a super-powered version of <code>map()</code> that lets you iterate over multiple inputs simultaneously.</p></li>
<li><p><code>pmap()</code> will then iterate through the two sets of inputs through <code>output_csv()</code> (the inputs are used as arguments), which then writes the three CSV files with the file names you want. For the “writing” function, you could either use <code>write_csv()</code> from <strong>readr</strong> (part of <strong>tidyverse</strong>) or <code>fwrite()</code> from <strong>data.table</strong>, depending on your workflow / style.</p></li>
</ol>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Step 1</span>
<span class="co"># Define a function for exporting csv with the desired file names and into the right path</span>
output_csv &lt;-<span class="st"> </span><span class="cf">function</span>(data, names){ 
    folder_path &lt;-<span class="st"> &quot;../datasets/test-excel/&quot;</span>
    
    <span class="kw">write_csv</span>(data, <span class="kw">paste0</span>(folder_path, <span class="st">&quot;test-excel-&quot;</span>, names, <span class="st">&quot;.csv&quot;</span>))
  }

<span class="co"># Step 2</span>
<span class="kw">list</span>(<span class="dt">data =</span> list_of_dfs,
     <span class="dt">names =</span> <span class="kw">names</span>(list_of_dfs)) <span class="op">%&gt;%</span><span class="st"> </span>
<span class="st">  </span>
<span class="co"># Step 3</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">pmap</span>(output_csv) </code></pre></div>
<p>The outcome of the above code is shown below. My directory now contains one Excel file with three Worksheets (sheet names are “setosa”, “versicolor”, and “virginica”), and three separate CSV files for each data slice:</p>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/export-excel.PNG" width="80%" /></p>
<hr />
</div>
</div>
<div id="reading-multiple-excel-csv-files" class="section level2">
<h2>Reading multiple Excel / CSV files</h2>
<p><img src="{{ site.url }}{{ site.baseurl }}/images/read-excel.gif" width="80%" /></p>
<p>For reading files in, you’ll need to decide on <em>how</em> you want them to be read in. The options are:</p>
<ol style="list-style-type: decimal">
<li>Read all the datasets directly into the Global Environment as individual data frames with a “separate existence” and separate names.</li>
<li>Read all the datasets into a single list, where each data frame is a member of that list.</li>
</ol>
<p>The first option is best if you are <strong>unlikely</strong> to run similar operations on all the data frames at the same time. You may for instance want to do this if the data sets that you are reading in are structurally different from each other, and that you are planning to manipulate them separately.</p>
<p>The second option will be best if you are likely to manipulate all the data frames at the same time, where for instance you may run on the list of data frames <code>map()</code> with <code>drop_na()</code> as an argument to remove missing values for all of the data frames at the same time. The benefit of reading your multiple data sets into a list is that you will have a much cleaner workspace (Global Environment). However, there is a minor and almost negligible inconvenience accessing individual data frames, as you will need to go into a list and pick out the right member of the list (e.g. doing something like <code>list_of_dfs[3]</code>).</p>
<div id="method-1a-read-all-sheets-in-excel-into-global-environment" class="section level3">
<h3>Method 1A: Read all sheets in Excel into Global Environment</h3>
<p>So let’s begin! This method will read all the sheets within a specified Excel file and load them into the Global Environment, using variable names of your own choice. For simplicity, I will use the original Excel sheet names as the variable names.</p>
<p>The first thing to do is to specify the file path to the Excel file:</p>
<div class="sourceCode" id="cb10"><pre class="sourceCode r"><code class="sourceCode r">wb_source &lt;-<span class="st"> &quot;../datasets/test-excel/test-excel.xlsx&quot;</span></code></pre></div>
<p>You can then run <code>readxl::excel_sheets()</code> to extract the sheet names in that Excel file, and save it as a character type vector.</p>
<div class="sourceCode" id="cb11"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Extract the sheet names as a character string vector</span>
wb_sheets &lt;-<span class="st"> </span>readxl<span class="op">::</span><span class="kw">excel_sheets</span>(wb_source) 

<span class="kw">print</span>(wb_sheets)</code></pre></div>
<pre><code>## [1] &quot;setosa&quot;     &quot;versicolor&quot; &quot;virginica&quot;</code></pre>
<p>The next step is to iterate through the sheet names (saved in <code>wb_sheets</code>) using <code>map()</code>, and within each iteration use <code>assign()</code> (base) and <code>read_xlsx()</code> (from <strong>readxl</strong>) to load each individual sheet into the Global Environment, giving each one a variable name. Here’s the code:</p>
<div class="sourceCode" id="cb13"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Load everything into the Global Environment</span>
wb_sheets <span class="op">%&gt;%</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="cf">function</span>(sheet){ <span class="co"># iterate through each sheet name</span>
  <span class="kw">assign</span>(<span class="dt">x =</span> sheet,
         <span class="dt">value =</span> readxl<span class="op">::</span><span class="kw">read_xlsx</span>(<span class="dt">path =</span> wb_source, <span class="dt">sheet =</span> sheet),
         <span class="dt">envir =</span> .GlobalEnv)
})</code></pre></div>
<p>This is what my work space looks like: <img src="{{ site.url }}{{ site.baseurl }}/images/import-excel.PNG" width="80%" /></p>
<p>Note that <code>map()</code> always returns a list, but in this case we do not need a list returned and only require the “side effects”, i.e. the objects being read in to be assigned to the Global Environment. If you prefer you can use <code>lapply()</code> instead of <code>map()</code>, which for this purpose doesn’t make a big practical difference.</p>
<p>Also, <code>assign()</code> allows you to assign a value to a name in an environment, where we’ve specified the following as arguments:</p>
<ul>
<li><strong>x</strong>: <code>sheet</code> as the variable name</li>
<li><strong>value</strong>: The actual data from the sheet we read in. Here, we use <code>readxl::read_xlsx()</code> for reading in specific sheets from the Excel file, where you simply specify the file path and the sheet name as the arguments.</li>
<li><strong>envir</strong>: <code>.GlobalEnv</code> as the environment</li>
</ul>
</div>
<div id="method-1b-read-all-csv-files-in-directory-into-global-environment" class="section level3">
<h3>Method 1B: Read all CSV files in directory into Global Environment</h3>
<p>The method for reading CSV files into a directory is slightly different, as you’ll need to find a way to identify or create a character vector of names of all the files that you want to load into R. To do this, we’ll use <code>list.files()</code>, which produces a character vector of the names of files or directories in the named directory:</p>
<div class="sourceCode" id="cb14"><pre class="sourceCode r"><code class="sourceCode r">file_path &lt;-<span class="st"> &quot;../datasets/test-excel/&quot;</span>

file_path <span class="op">%&gt;%</span><span class="st"> </span><span class="kw">list.files</span>()</code></pre></div>
<pre><code>## [1] &quot;test-excel-setosa.csv&quot;     &quot;test-excel-versicolor.csv&quot;
## [3] &quot;test-excel-virginica.csv&quot;  &quot;test-excel.xlsx&quot;</code></pre>
<p>We only want CSV files in this instance, so we’ll want to do a bit of string manipulation (using <code>str_detect()</code> from <strong>stringr</strong> - again, from <strong>tidyverse</strong>) to get only the names that end with the extension “.csv”. Let’s pipe this along:</p>
<div class="sourceCode" id="cb16"><pre class="sourceCode r"><code class="sourceCode r">file_path <span class="op">%&gt;%</span>
  <span class="kw">list.files</span>() <span class="op">%&gt;%</span>
<span class="st">  </span>.[<span class="kw">str_detect</span>(., <span class="st">&quot;.csv&quot;</span>)] -&gt;<span class="st"> </span>csv_file_names

csv_file_names</code></pre></div>
<pre><code>## [1] &quot;test-excel-setosa.csv&quot;     &quot;test-excel-versicolor.csv&quot;
## [3] &quot;test-excel-virginica.csv&quot;</code></pre>
<p>The next part is similar to what we’ve done earlier, using <code>map()</code>. Note that apart from replacing the <code>value</code> argument with <code>read_csv()</code> (or you can use <code>fread()</code> to return a <strong>data.table</strong> object rather than a <strong>tibble</strong>), I also removed the file extension in the <code>x</code> argument so that the variable names would not contain the actual characters “.csv”:</p>
<div class="sourceCode" id="cb18"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Load everything into the Global Environment</span>
csv_file_names <span class="op">%&gt;%</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="cf">function</span>(file_name){ <span class="co"># iterate through each file name</span>
  <span class="kw">assign</span>(<span class="dt">x =</span> <span class="kw">str_remove</span>(file_name, <span class="st">&quot;.csv&quot;</span>), <span class="co"># Remove file extension &quot;.csv&quot;</span>
         <span class="dt">value =</span> <span class="kw">read_csv</span>(<span class="kw">paste0</span>(file_path, file_name)),
         <span class="dt">envir =</span> .GlobalEnv)
})</code></pre></div>
</div>
<div id="method-2a-read-all-sheets-in-excel-into-a-list" class="section level3">
<h3>Method 2A: Read all sheets in Excel into a list</h3>
<p>Reading sheets into a list is actually easier than to read it into the Global Environment, as <code>map()</code> returns a list and you won’t have to use <code>assign()</code> or specify a variable name. Recall that <code>wb_source</code> holds the path of the Excel file, and <code>wb_sheets</code> is a character vector of all the sheet names in the Excel file:</p>
<div class="sourceCode" id="cb19"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Load everything into the Global Environment</span>
wb_sheets <span class="op">%&gt;%</span>
<span class="st">  </span>purrr<span class="op">::</span><span class="kw">map</span>(<span class="cf">function</span>(sheet){ <span class="co"># iterate through each sheet name</span>
  readxl<span class="op">::</span><span class="kw">read_xlsx</span>(<span class="dt">path =</span> wb_source, <span class="dt">sheet =</span> sheet)
}) -&gt;<span class="st"> </span>df_list_read <span class="co"># Assign to a list</span></code></pre></div>
<p>You can then use <code>map()</code> again to run operations across all members of the list, and even chain operations within it:</p>
<div class="sourceCode" id="cb20"><pre class="sourceCode r"><code class="sourceCode r">df_list_read <span class="op">%&gt;%</span>
<span class="st">  </span><span class="kw">map</span>(<span class="op">~</span><span class="kw">select</span>(., Petal.Length, Species) <span class="op">%&gt;%</span>
<span class="st">        </span><span class="kw">head</span>())</code></pre></div>
<pre><code>## [[1]]
## # A tibble: 6 x 2
##   Petal.Length Species
##          &lt;dbl&gt; &lt;chr&gt;  
## 1          1.4 setosa 
## 2          1.4 setosa 
## 3          1.3 setosa 
## 4          1.5 setosa 
## 5          1.4 setosa 
## 6          1.7 setosa 
## 
## [[2]]
## # A tibble: 6 x 2
##   Petal.Length Species   
##          &lt;dbl&gt; &lt;chr&gt;     
## 1          4.7 versicolor
## 2          4.5 versicolor
## 3          4.9 versicolor
## 4          4   versicolor
## 5          4.6 versicolor
## 6          4.5 versicolor
## 
## [[3]]
## # A tibble: 6 x 2
##   Petal.Length Species  
##          &lt;dbl&gt; &lt;chr&gt;    
## 1          6   virginica
## 2          5.1 virginica
## 3          5.9 virginica
## 4          5.6 virginica
## 5          5.8 virginica
## 6          6.6 virginica</code></pre>
</div>
<div id="method-2b-read-all-csv-files-in-directory-into-a-list" class="section level3">
<h3>Method 2B: Read all CSV files in directory into a list</h3>
<p>At this point you’ve probably gathered how you can adapt the code to read CSV files into a list, but let’s cover this for comprehensiveness. No <code>assign()</code> needed, and only run <code>read_csv()</code> within the <code>map()</code> function, iterating through the file names:</p>
<div class="sourceCode" id="cb22"><pre class="sourceCode r"><code class="sourceCode r"><span class="co"># Load everything into the Global Environment</span>
csv_file_names <span class="op">%&gt;%</span>
  purrr<span class="op">::</span><span class="kw">map</span>(<span class="cf">function</span>(file_name){ <span class="co"># iterate through each file name</span>
  
  <span class="kw">read_csv</span>(<span class="kw">paste0</span>(file_path, file_name))
  
}) -&gt;<span class="st"> </span>df_list_read2 <span class="co"># Assign to a list</span></code></pre></div>
<hr />
</div>
</div>
<div id="thank-you-for-reading" class="section level2">
<h2>Thank you for reading! 😄</h2>
<p>Hopefully this is a helpful tutorial for an iterative approach to writing and reading Excel files. If you like what you read or if you have any suggestions / thoughts about the subject, do leave a comment in the Disqus fields in the blog and let me know!</p>
</div>
</section>
