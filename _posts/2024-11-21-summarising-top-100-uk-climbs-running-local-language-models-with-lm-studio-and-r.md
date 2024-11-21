---
title: "Summarising Top 100 UK Climbs: Running Local Language Models with LM Studio and R"

author: "Martin Chan"
date: "November 21, 2024"
tags: rstats LLMs GenAI tidyverse
layout: post
image: https://raw.githubusercontent.com/martinctc/blog/master/images/lm-studio/pidcock.gif
---

<script src="{{ site.url }}{{ site.baseurl }}/knitr_files/Local_Language_Models_with_LM_Studio_and_R_files/header-attrs-2.29/header-attrs.js"></script>

<section class="main-content">
<div id="introduction" class="section level2">
<h2>Introduction</h2>
<p>Since my last entry on this blog, the landscape of data science has
been massively disrupted by the advent of large language models (LLM).
Areas in data science such as text mining and natural language
processing have been revolutionised by the capabilities of these
models.</p>
<p>Remember the days of manually tagging and reading through text data?
Well, they’re long gone, and I can only say that <a
href="https://martinctc.github.io/blog/a-short-r-package-review-rqda/">not
all blog posts age equally well</a> (RQDA was one of my favourite R
packages for analysing qualitative data; not only is it now redundant,
it is also no longer available on CRAN). I am also not sure that there
is much value anymore in <a
href="https://martinctc.github.io/blog/Copy-and-paste_wordclouds_in_R/">using
n-gram / word frequency as well as word clouds to surface key themes
from a large corpus of text data</a>, when you can simply use a LLM
these days to generate summaries and insights.</p>
<p>To get with the times (!), I have decided to explore the capabilities
of <a href="https://lmstudio.ai/">LM Studio</a>, a platform that allows
you to run language models <em>locally</em>. The benefits of running a
language model locally are:</p>
<ul>
<li>you can interact with it directly from your R environment, without
the need to rely on cloud-based services.</li>
<li>There is no need to pay for API calls - as long as you can afford
the electricity bill to run your computer, you can generate as much text
as you want!</li>
</ul>
<p>In this blog post, I will guide you through the process of setting up
LM Studio, integrating it with R, and applying it to a dataset on <a
href="https://cyclinguphill.com/100-climbs/">UK’s top 100 cycling
climbs</a> (my latest pastime). We will create a custom function to
interact with the language model, generate prompts for the model, and
visualize the results. Let’s get started!</p>
<div class="float">
<img
src="https://raw.githubusercontent.com/martinctc/blog/master/images/lm-studio/pidcock.gif"
alt="image from Giphy" />
<div class="figcaption">image from Giphy</div>
</div>
</div>
<div id="setting-up-lm-studio" class="section level2">
<h2>Setting Up LM Studio</h2>
<div id="install-lm-studio-and-download-models" class="section level3">
<h3>Install LM Studio and download models</h3>
<p>Before we begin, ensure you have the following installed:</p>
<ul>
<li>R</li>
<li>LM Studio, which can be downloaded from the <a
href="https://lmstudio.com/download">LM Studio website</a></li>
</ul>
<p>After you have downloaded and installed LM Studio, open the
application. Go to the <strong>Discover</strong> tab (sidebar), where
you can browse and search for models. In this example, we will be using
the <a
href="https://huggingface.co/microsoft/Phi-3-mini-4k-instruct">Phi-3-mini-4k-instruct</a>
model, but you can of course experiment with any other model that you
prefer - as long as you’ve got the hardware to run it!</p>
<p>Now, select the model from the top bar to load it:</p>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\lm-studio\load-model.png" width="80%" /></p>
<p>To check that everything is working fine, go to the
<strong>Chat</strong> tab on the sidebar and start a new chat to
interact with the Phi-3 model directly. You’ve now got your language
model up and running!</p>
</div>
<div id="required-r-packages" class="section level3">
<h3>Required R Packages</h3>
<p>To effectively work with LM Studio, we will need several R
packages:</p>
<ul>
<li><strong>tidyverse</strong> - for data manipulation</li>
<li><strong>httr</strong> - for API interaction</li>
<li><strong>jsonlite</strong> - for JSON parsing</li>
</ul>
<p>You can install/update them all with one line of code:</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1" tabindex="-1"></a><span class="co"># Install necessary packages</span></span>
<span id="cb1-2"><a href="#cb1-2" tabindex="-1"></a><span class="fu">install.packages</span>(<span class="fu">c</span>(<span class="st">&quot;tidyverse&quot;</span>, <span class="st">&quot;httr&quot;</span>, <span class="st">&quot;jsonlite&quot;</span>))</span></code></pre></div>
<p>Let us set up the R script by loading the packages and the data we
will be working with:</p>
<div class="sourceCode" id="cb2"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb2-1"><a href="#cb2-1" tabindex="-1"></a><span class="co"># Load the packages</span></span>
<span id="cb2-2"><a href="#cb2-2" tabindex="-1"></a><span class="fu">library</span>(tidyverse)</span>
<span id="cb2-3"><a href="#cb2-3" tabindex="-1"></a><span class="fu">library</span>(httr)</span>
<span id="cb2-4"><a href="#cb2-4" tabindex="-1"></a><span class="fu">library</span>(jsonlite)</span>
<span id="cb2-5"><a href="#cb2-5" tabindex="-1"></a></span>
<span id="cb2-6"><a href="#cb2-6" tabindex="-1"></a>top_100_climbs_df <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="st">&quot;https://raw.githubusercontent.com/martinctc/blog/refs/heads/master/datasets/top_100_climbs.csv&quot;</span>)</span></code></pre></div>
<p>The <code>top_100_climbs_df</code> dataset contains information on
the top 100 cycling climbs in the UK, which I’ve pulled from the <a
href="https://cyclinguphill.com/100-climbs/">Cycling Uphill website</a>,
originally put together by <a
href="https://www.100climbs.co.uk/contact-me">Simon Warren</a>. These
are 100 rows, and the following columns in the dataset:</p>
<ul>
<li><code>climb_id</code>: row unique identifier for the climb</li>
<li><code>climb</code>: name of the climb</li>
<li><code>height_gain_m</code>: height gain in meters</li>
<li><code>average_gradient</code>: average gradient of the climb</li>
<li><code>length_km</code>: total length of the climb in kilometers</li>
<li><code>max_gradient</code>: maximum gradient of the climb</li>
<li><code>url</code>: URL to the climb’s page on Cycling Uphill</li>
</ul>
<p>Here is what the dataset looks like when we run
<code>dplyr::glimpse()</code>:</p>
<div class="sourceCode" id="cb3"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1" tabindex="-1"></a><span class="fu">glimpse</span>(top_100_climbs_df)</span></code></pre></div>
<pre><code>## Rows: 100
## Columns: 7
## $ climb_id         &lt;dbl&gt; 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16…
## $ climb            &lt;chr&gt; &quot;Cheddar Gorge&quot;, &quot;Weston Hill&quot;, &quot;Crowcombe Combe&quot;, &quot;P…
## $ height_gain_m    &lt;dbl&gt; 150, 165, 188, 372, 326, 406, 166, 125, 335, 163, 346…
## $ average_gradient &lt;dbl&gt; 0.05, 0.09, 0.15, 0.12, 0.10, 0.04, 0.11, 0.11, 0.06,…
## $ length_km        &lt;dbl&gt; 3.5, 1.8, 1.2, 4.9, 3.2, 11.0, 1.5, 1.1, 5.4, 1.4, 9.…
## $ max_gradient     &lt;dbl&gt; 0.16, 0.18, 0.25, 0.25, 0.17, 0.12, 0.25, 0.18, 0.12,…
## $ url              &lt;chr&gt; &quot;https://cyclinguphill.com/cheddar-gorge/&quot;, &quot;https://…</code></pre>
<p>Our goal here is to use this dataset to generate text descriptions
for each of the climbs using the language model. Since this is for text
generation, we will do a bit of cleaning up of the dataset, converting
gradient values to percentages:</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1" tabindex="-1"></a>top_100_climbs_df_clean <span class="ot">&lt;-</span> top_100_climbs_df <span class="sc">%&gt;%</span></span>
<span id="cb5-2"><a href="#cb5-2" tabindex="-1"></a>  <span class="fu">mutate</span>(</span>
<span id="cb5-3"><a href="#cb5-3" tabindex="-1"></a>    <span class="at">average_gradient =</span> scales<span class="sc">::</span><span class="fu">percent</span>(average_gradient),</span>
<span id="cb5-4"><a href="#cb5-4" tabindex="-1"></a>    <span class="at">max_gradient =</span> scales<span class="sc">::</span><span class="fu">percent</span>(max_gradient)</span>
<span id="cb5-5"><a href="#cb5-5" tabindex="-1"></a>    )</span></code></pre></div>
</div>
<div id="setting-up-the-local-endpoint" class="section level3">
<h3>Setting up the Local Endpoint</h3>
<p>Once you have got your model in LM Studio up and running, you can set
up a local endpoint to interact with it directly from your R
environment.</p>
<p>To do this, go to the <strong>Developer</strong> tab on the sidebar,
and click ‘Start Server (Ctrl + R)’.</p>
<p>Setting up a local endpoint allows you to interact with the language
model directly from your R environment. If you leave your default
settings unchanged, your endpoints should be as follows:</p>
<ul>
<li>GET <a href="http://localhost:1234/v1/models"
class="uri">http://localhost:1234/v1/models</a></li>
<li>POST <a href="http://localhost:1234/v1/chat/completions"
class="uri">http://localhost:1234/v1/chat/completions</a></li>
<li>POST <a href="http://localhost:1234/v1/completions"
class="uri">http://localhost:1234/v1/completions</a></li>
<li>POST <a href="http://localhost:1234/v1/embeddings"
class="uri">http://localhost:1234/v1/embeddings</a></li>
</ul>
<p><img src="{{ site.url }}{{ site.baseurl }}\images\lm-studio\start-server.png" width="80%" /></p>
<p>In this article, we will be using the chat completions endpoint for
summarising / generating text.</p>
</div>
</div>
<div id="writing-a-custom-function-to-connect-to-the-local-endpoint"
class="section level2">
<h2>Writing a Custom Function to Connect to the Local Endpoint</h2>
<p>The next step here is to write a custom function that will allow us
to send our prompt to the local endpoint and retrieve the response from
the language model. Since we have 100 climbs to describe, writing a
custom function allows us to scale the logic for interacting with the
model, which save us time and reduces the risk of errors. We can also
reuse this function as a template for other future projects.</p>
<div id="creating-a-custom-function" class="section level3">
<h3>Creating a custom function</h3>
<p>Below is a code snippet for creating a custom function to communicate
with your local LM Studio endpoint:</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb6-1"><a href="#cb6-1" tabindex="-1"></a><span class="co"># Define a function to connect to the local endpoint</span></span>
<span id="cb6-2"><a href="#cb6-2" tabindex="-1"></a>send_prompt <span class="ot">&lt;-</span> <span class="cf">function</span>(system_prompt, user_prompt, <span class="at">endpoint =</span> <span class="st">&quot;http://localhost:1234/v1/chat/completions&quot;</span>) {</span>
<span id="cb6-3"><a href="#cb6-3" tabindex="-1"></a></span>
<span id="cb6-4"><a href="#cb6-4" tabindex="-1"></a>  <span class="co"># Define the data payload for the local server</span></span>
<span id="cb6-5"><a href="#cb6-5" tabindex="-1"></a>  data_payload <span class="ot">&lt;-</span> <span class="fu">list</span>(</span>
<span id="cb6-6"><a href="#cb6-6" tabindex="-1"></a>    <span class="at">messages =</span> <span class="fu">list</span>(</span>
<span id="cb6-7"><a href="#cb6-7" tabindex="-1"></a>      <span class="fu">list</span>(<span class="at">role =</span> <span class="st">&quot;system&quot;</span>, <span class="at">content =</span> system_prompt),</span>
<span id="cb6-8"><a href="#cb6-8" tabindex="-1"></a>      <span class="fu">list</span>(<span class="at">role =</span> <span class="st">&quot;user&quot;</span>, <span class="at">content =</span> user_prompt)</span>
<span id="cb6-9"><a href="#cb6-9" tabindex="-1"></a>    ),</span>
<span id="cb6-10"><a href="#cb6-10" tabindex="-1"></a>    <span class="at">temperature =</span> <span class="fl">0.7</span>,</span>
<span id="cb6-11"><a href="#cb6-11" tabindex="-1"></a>    <span class="at">max_tokens =</span> <span class="dv">500</span>,</span>
<span id="cb6-12"><a href="#cb6-12" tabindex="-1"></a>    <span class="at">top_p =</span> <span class="fl">0.9</span>,</span>
<span id="cb6-13"><a href="#cb6-13" tabindex="-1"></a>    <span class="at">frequency_penalty =</span> <span class="fl">0.0</span>,</span>
<span id="cb6-14"><a href="#cb6-14" tabindex="-1"></a>    <span class="at">presence_penalty =</span> <span class="fl">0.0</span></span>
<span id="cb6-15"><a href="#cb6-15" tabindex="-1"></a>  )</span>
<span id="cb6-16"><a href="#cb6-16" tabindex="-1"></a></span>
<span id="cb6-17"><a href="#cb6-17" tabindex="-1"></a>  <span class="co"># Convert the data to JSON</span></span>
<span id="cb6-18"><a href="#cb6-18" tabindex="-1"></a>  json_body <span class="ot">&lt;-</span> <span class="fu">toJSON</span>(data_payload, <span class="at">auto_unbox =</span> <span class="cn">TRUE</span>)</span>
<span id="cb6-19"><a href="#cb6-19" tabindex="-1"></a>  </span>
<span id="cb6-20"><a href="#cb6-20" tabindex="-1"></a>  <span class="co"># Define the URL of the local server</span></span>
<span id="cb6-21"><a href="#cb6-21" tabindex="-1"></a>  response <span class="ot">&lt;-</span> <span class="fu">POST</span>(</span>
<span id="cb6-22"><a href="#cb6-22" tabindex="-1"></a>    endpoint, </span>
<span id="cb6-23"><a href="#cb6-23" tabindex="-1"></a>    <span class="fu">add_headers</span>(</span>
<span id="cb6-24"><a href="#cb6-24" tabindex="-1"></a>      <span class="st">&quot;Content-Type&quot;</span> <span class="ot">=</span> <span class="st">&quot;application/json&quot;</span>),</span>
<span id="cb6-25"><a href="#cb6-25" tabindex="-1"></a>    <span class="at">body =</span> json_body,</span>
<span id="cb6-26"><a href="#cb6-26" tabindex="-1"></a>    <span class="at">encode =</span> <span class="st">&quot;json&quot;</span>)</span>
<span id="cb6-27"><a href="#cb6-27" tabindex="-1"></a></span>
<span id="cb6-28"><a href="#cb6-28" tabindex="-1"></a>  <span class="cf">if</span> (response<span class="sc">$</span>status_code <span class="sc">==</span> <span class="dv">200</span>) {</span>
<span id="cb6-29"><a href="#cb6-29" tabindex="-1"></a>    <span class="co"># Parse response and return the content in JSON format</span></span>
<span id="cb6-30"><a href="#cb6-30" tabindex="-1"></a>    response_content <span class="ot">&lt;-</span> <span class="fu">content</span>(response, <span class="at">as =</span> <span class="st">&quot;parsed&quot;</span>, <span class="at">type =</span> <span class="st">&quot;application/json&quot;</span>)</span>
<span id="cb6-31"><a href="#cb6-31" tabindex="-1"></a>    response_text <span class="ot">&lt;-</span> response_content<span class="sc">$</span>choices[[<span class="dv">1</span>]]<span class="sc">$</span>message<span class="sc">$</span>content</span>
<span id="cb6-32"><a href="#cb6-32" tabindex="-1"></a>    response_text</span>
<span id="cb6-33"><a href="#cb6-33" tabindex="-1"></a></span>
<span id="cb6-34"><a href="#cb6-34" tabindex="-1"></a>  } <span class="cf">else</span> {</span>
<span id="cb6-35"><a href="#cb6-35" tabindex="-1"></a>    <span class="fu">stop</span>(<span class="st">&quot;Error: Unable to connect to the language model&quot;</span>)</span>
<span id="cb6-36"><a href="#cb6-36" tabindex="-1"></a>  }</span>
<span id="cb6-37"><a href="#cb6-37" tabindex="-1"></a>}</span></code></pre></div>
<p>There are a couple of things to note in this function:</p>
<ol style="list-style-type: decimal">
<li>The <code>send_prompt</code> function takes in three arguments:
<code>system_prompt</code>, <code>user_prompt</code>, and
<code>endpoint</code>.</li>
</ol>
<ul>
<li>We distinguish between the system and user prompts here, which is
typically not necessary for a simple chat completion. However, it is
useful for more complex interactions where you want to guide the model
with specific prompts. The system prompt is typically used for providing
overall guidance, context, tone, and boundaries for the behaviour of the
AI, while the user prompt is the actual input that you want the AI to
respond to.</li>
<li>The <code>endpoint</code> is the URL of the local server that we are
connecting to. Note that we have used the chat completions endpoint
here.</li>
</ul>
<ol start="2" style="list-style-type: decimal">
<li>The <code>data_payload</code> is a list that contains the messages
(prompts) and the parameters that you can adjust to control the output
of the language model. These parameters can vary depending on the model
you are using - I typically search for the “API documentation” or the
“API reference” for the model as a guide. Here are the <a
href="https://deepinfra.com/microsoft/Phi-3-medium-4k-instruct/api">parameters
we are using in this example</a>:</li>
</ol>
<ul>
<li><code>messages</code> is a list of messages that the language model
will use to generate the text. In this case, we have a system message
and a user message.</li>
<li><code>temperature</code> controls the randomness of the output. A
higher temperature will result in more random output.</li>
<li><code>max_tokens</code> is the maximum number of tokens that the
language model will generate.</li>
<li><code>top_p</code> is the nucleus sampling parameter, and an
alternative to sampling with temperature. It controls the probability
mass that the model considers when generating the next token.</li>
<li><code>frequency_penalty</code> and <code>presence_penalty</code> are
used to penalize the model for repeating tokens or generating
low-frequency tokens.</li>
</ul>
<ol start="3" style="list-style-type: decimal">
<li><p>The <code>json_body</code> is the JSON representation of the
<code>data_payload</code> list. We need to transform the list into JSON
format because this is what is expected by the local server. We do this
with <code>jsonlite::toJSON()</code>.</p></li>
<li><p>The <code>response</code> object is the result of sending a POST
request to the local server. If the status code of the response is 200,
then we return the content of the response. If there is an error, we
stop the function and print an error message.</p></li>
</ol>
<p>Now that we have our function, let us test it out!</p>
</div>
<div id="testing-the-function" class="section level3">
<h3>Testing the Function</h3>
<p>To ensure your function works as expected, run a simple test:</p>
<div class="sourceCode" id="cb7"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb7-1"><a href="#cb7-1" tabindex="-1"></a><span class="co"># Test the generate_text function</span></span>
<span id="cb7-2"><a href="#cb7-2" tabindex="-1"></a>test_hill <span class="ot">&lt;-</span> top_100_climbs_df_clean <span class="sc">%&gt;%</span></span>
<span id="cb7-3"><a href="#cb7-3" tabindex="-1"></a>  <span class="fu">slice</span>(<span class="dv">1</span>) <span class="sc">%&gt;%</span> <span class="co"># Select the first row</span></span>
<span id="cb7-4"><a href="#cb7-4" tabindex="-1"></a>  jsonlite<span class="sc">::</span><span class="fu">toJSON</span>()</span>
<span id="cb7-5"><a href="#cb7-5" tabindex="-1"></a></span>
<span id="cb7-6"><a href="#cb7-6" tabindex="-1"></a><span class="fu">send_prompt</span>(</span>
<span id="cb7-7"><a href="#cb7-7" tabindex="-1"></a>  <span class="at">system_prompt =</span> <span class="fu">paste</span>(</span>
<span id="cb7-8"><a href="#cb7-8" tabindex="-1"></a>    <span class="st">&quot;You are a sports commentator for the Tour de France.&quot;</span>,</span>
<span id="cb7-9"><a href="#cb7-9" tabindex="-1"></a>    <span class="st">&quot;Describe the following climb to the audience in less than 200 words, using the data.&quot;</span></span>
<span id="cb7-10"><a href="#cb7-10" tabindex="-1"></a>  ),</span>
<span id="cb7-11"><a href="#cb7-11" tabindex="-1"></a>  <span class="at">user_prompt =</span> test_hill</span>
<span id="cb7-12"><a href="#cb7-12" tabindex="-1"></a>  )</span></code></pre></div>
<pre><code>## [1] &quot;Ladies and gentlemen, hold on to your helmets as we approach the infamous Cheddar Gorge climb – a true testament of resilience for any cyclist tackling this segment! Standing at an imposing height gain of approximately 150 meters over its lengthy stretch spanning just under four kilometers, it demands every last drop from our riders. The average gradient here is pitched at around a challenging 5%, but beware – the climb isn&#39;t forgiving with occasional sections that reach up to an extreme 16%! It’s not for the faint-hearted and certainly no place for those looking for respite along this grueling ascent. The Cheddar Gorge will separate contenders from pretenders, all in one breathtakingly scenic setting – a true masterclass of endurance that is sure to make any Tour de France rider&#39;s legs scream!&quot;</code></pre>
<p>Not too bad, right?</p>
</div>
</div>
<div id="running-a-prompt-template-on-the-top-100-climbs-dataset"
class="section level2">
<h2>Running a prompt template on the Top 100 Climbs dataset</h2>
<p>What we have created in the previous section are effectively a prompt
template for the system prompt, and the user prompt is made up of the
data we have on the climbs, converted to JSON format. To apply this
programmatically to all the 100 climbs, we can make use of the
<code>purrr::pmap()</code> function in <strong>tidyverse</strong>, which
can take a data frame as an input parameter and apply a function to each
row of the data frame:</p>
<div class="sourceCode" id="cb9"><pre class="sourceCode r"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1" tabindex="-1"></a><span class="co"># Define system prompt</span></span>
<span id="cb9-2"><a href="#cb9-2" tabindex="-1"></a>sys_prompt <span class="ot">&lt;-</span> <span class="fu">paste</span>(</span>
<span id="cb9-3"><a href="#cb9-3" tabindex="-1"></a>  <span class="st">&quot;I have the following data regarding a top 100 climb for road cycling in the UK.&quot;</span>,</span>
<span id="cb9-4"><a href="#cb9-4" tabindex="-1"></a>  <span class="st">&quot;Please help me generate a description based on the available columns, ending with a URL for the reader to find more information.&quot;</span></span>
<span id="cb9-5"><a href="#cb9-5" tabindex="-1"></a>)</span>
<span id="cb9-6"><a href="#cb9-6" tabindex="-1"></a></span>
<span id="cb9-7"><a href="#cb9-7" tabindex="-1"></a><span class="co"># Generated descriptions for all climbs</span></span>
<span id="cb9-8"><a href="#cb9-8" tabindex="-1"></a>top_100_climbs_with_desc <span class="ot">&lt;-</span></span>
<span id="cb9-9"><a href="#cb9-9" tabindex="-1"></a>  top_100_climbs_df_clean <span class="sc">%&gt;%</span></span>
<span id="cb9-10"><a href="#cb9-10" tabindex="-1"></a>  <span class="fu">pmap_dfr</span>(<span class="cf">function</span>(climb_id, climb, height_gain_m, average_gradient, length_km, max_gradient, url) {</span>
<span id="cb9-11"><a href="#cb9-11" tabindex="-1"></a>    user_prompt <span class="ot">&lt;-</span> jsonlite<span class="sc">::</span><span class="fu">toJSON</span>(</span>
<span id="cb9-12"><a href="#cb9-12" tabindex="-1"></a>      <span class="fu">list</span>(</span>
<span id="cb9-13"><a href="#cb9-13" tabindex="-1"></a>        <span class="at">climb =</span> climb,</span>
<span id="cb9-14"><a href="#cb9-14" tabindex="-1"></a>        <span class="at">height_gain_m =</span> height_gain_m,</span>
<span id="cb9-15"><a href="#cb9-15" tabindex="-1"></a>        <span class="at">average_gradient =</span> average_gradient,</span>
<span id="cb9-16"><a href="#cb9-16" tabindex="-1"></a>        <span class="at">length_km =</span> length_km,</span>
<span id="cb9-17"><a href="#cb9-17" tabindex="-1"></a>        <span class="at">max_gradient =</span> max_gradient,</span>
<span id="cb9-18"><a href="#cb9-18" tabindex="-1"></a>        <span class="at">url =</span> url</span>
<span id="cb9-19"><a href="#cb9-19" tabindex="-1"></a>        )</span>
<span id="cb9-20"><a href="#cb9-20" tabindex="-1"></a>        )</span>
<span id="cb9-21"><a href="#cb9-21" tabindex="-1"></a>    </span>
<span id="cb9-22"><a href="#cb9-22" tabindex="-1"></a>    <span class="co"># climb description</span></span>
<span id="cb9-23"><a href="#cb9-23" tabindex="-1"></a>    climb_desc <span class="ot">&lt;-</span> <span class="fu">send_prompt</span>(<span class="at">system_prompt =</span> sys_prompt, <span class="at">user_prompt =</span> user_prompt)</span>
<span id="cb9-24"><a href="#cb9-24" tabindex="-1"></a></span>
<span id="cb9-25"><a href="#cb9-25" tabindex="-1"></a>    <span class="co"># Return original data frame with climb description appended as column</span></span>
<span id="cb9-26"><a href="#cb9-26" tabindex="-1"></a>    <span class="fu">tibble</span>(</span>
<span id="cb9-27"><a href="#cb9-27" tabindex="-1"></a>      <span class="at">climb_id =</span> climb_id,</span>
<span id="cb9-28"><a href="#cb9-28" tabindex="-1"></a>      <span class="at">climb =</span> climb,</span>
<span id="cb9-29"><a href="#cb9-29" tabindex="-1"></a>      <span class="at">height_gain_m =</span> height_gain_m,</span>
<span id="cb9-30"><a href="#cb9-30" tabindex="-1"></a>      <span class="at">average_gradient =</span> average_gradient,</span>
<span id="cb9-31"><a href="#cb9-31" tabindex="-1"></a>      <span class="at">length_km =</span> length_km,</span>
<span id="cb9-32"><a href="#cb9-32" tabindex="-1"></a>      <span class="at">max_gradient =</span> max_gradient,</span>
<span id="cb9-33"><a href="#cb9-33" tabindex="-1"></a>      <span class="at">url =</span> url,</span>
<span id="cb9-34"><a href="#cb9-34" tabindex="-1"></a>      <span class="at">description =</span> climb_desc</span>
<span id="cb9-35"><a href="#cb9-35" tabindex="-1"></a>    )</span>
<span id="cb9-36"><a href="#cb9-36" tabindex="-1"></a>  })</span></code></pre></div>
<p>The <code>top_100_climbs_with_desc</code> data frame now contains the
original data on the top 100 climbs, with an additional column
<code>description</code> that contains the text generated by the
language model. Note that this part might take a little while to run,
depending on the specs of your computer and which model you are
using.</p>
<p>Here are a few examples of the generated descriptions:</p>
<blockquote>
<p>Box Hill is a challenging climb in the UK, with an average gradient
of approximately 5%, and it stretches over a distance of just under 2
kilometers (130 meters height gain). The maximum gradient encountered on
this ascent reaches up to 6%. For more detailed information about Box
Hill’s topography and statistics for road cyclists, you can visit the
Cyclinguphill website: <a
href="https://cyclinguphill.com/box-hill/">https://cyclinguphill.com/box-hill/</a></p>
</blockquote>
<blockquote>
<p>Ditchling Beacon stands as a formidable challenge within the UK’s top
climbs for road cycling, boasting an elevation gain of 142 meters over
its length. With an average gradient that steepens at around 10%,
cyclists can expect to face some serious resistance on this uphill
battle. The total distance covered while tackling the full ascent is
approximately 1.4 kilometers, and it’s noteworthy for reaching a maximum
gradient of up to 17%. For those keenly interested in road cycling
climbs or looking to test their mettle against Ditchling Beacon’s steep
inclines, further details are readily available at <a
href="https://cyclinguphill.com/100-climbs/ditchling-beacon/">https://cyclinguphill.com/100-climbs/ditchling-beacon/</a>.</p>
</blockquote>
<blockquote>
<p>Swains Lane is a challenging road climb featured on the top 100 list
for UK cycling enthusiasts, standing proudly at number one with its
distinctive characteristics: it offers an ascent of 71 meters over just
under half a kilometer (0.9 km). The average gradient throughout this
route maintains a steady and formidable challenge to riders, peaking at
approximately eight percent—a testament to the climb’s consistent
difficulty level. For those seeking even more rigorous testing grounds,
Swains Lane features sections where cyclists can face gradients soaring
up to an impressive 20%, which not only pushes physical limits but also
demands a high degree of technical skill and mental fortitude from the
riders tackling this climb.Riders looking for more detailed information
about this top-tier British road ascent can visit <a
href="https://cyclinguphill.com/swains-lane/">https://cyclinguphill.com/swains-lane/</a>
where they will find comprehensive insights, including historical data
on past climbs and comparisons with other challenging routes across the
UK cycling landscape.</p>
</blockquote>
<p>If you are interested in exploring the entire dataset with the
generated column, you can download this <a
href="https://github.com/martinctc/blog/blob/master/datasets/top_100_climbs_with_descriptions.csv">here</a>.</p>
</div>
<div id="conclusion" class="section level2">
<h2>Conclusion</h2>
<p>In this blog, we’ve explored the process of setting up LM Studio and
integrating local language models into your R workflow. We discussed
installation, creating custom functions to interact with the model,
setting up prompt templates, and ultimately generating text descriptions
from a climbing dataset.</p>
<p>Now it’s your turn! Try implementing the methods outlined in this
blog and share your experiences or questions in the comments section
below. Happy coding!</p>
</div>
</section>
