---
title: "Data Chats: From Physics student to Data Science Consultant"

author: "Martin Chan"
date: "September 4, 2019"
layout: post
tags: interviews learning-r tidyverse
---


<section class="main-content">
<div id="introduction" class="section level2">
<h2>Introduction</h2>
<p>How do you begin a career in analytics and data science? What’s the best way of learning R? Should I still bother with Excel?</p>
<p>Arguably, these are some questions that you can gain more insights on by speaking to people than running models. This week, I have the pleasure of speaking with Abhishek Modi, to find out about his journey from a Physics student to a Data Science Consultant at Deloitte.</p>
<div id="about-abhishek" class="section level3">
<h3>About Abhishek</h3>
<p><img src="https://martinctc.github.io/blog/images/abhishek.jpeg" width="300px" /></p>
<p>Abhishek is a Data Science consultant for Deloitte and has experience in this domain of 4 years. He decided to go into Data Science after graduating from National Institute of Technology, Surat with a master’s degree in Physics. Abhishek has worked with Fortune 100 companies to help their IT, Sales, and Marketing teams with data-driven decision using advanced analytics. Please feel free to get in touch with Abhishek <a href="https://www.linkedin.com/in/atmodi/">via LinkedIn.</a></p>
<hr />
</div>
</div>
<div id="interview-with-abhishek-modi" class="section level2">
<h2>Interview with Abhishek Modi 🎤</h2>
<p><strong>To start, could you tell me a bit about what you currently do, and what is your background?</strong></p>
<p>I did my Bachelor’s and Master’s in Physics, where my interest was in the design of particle accelerators, and even my master’s thesis was on the same topic. During the dissertation period, I explored a lot of fields within and outside Physics. During this time, I came across <a href="https://fivethirtyeight.com/">FiveThreeEight</a>, and was surprised at how accurate predictions were made in 2008 US elections. This led to my desire to interview for data analytics companies at an entry level, and soon I got an offer from one.</p>
<p>Now, after 4 years, I am working as a Consultant for Deloitte in their Analytics and Cognitive team based in Bangalore, India. My toolbox containts R, SQL, and Excel for 99% of the tasks.</p>
<p><img src="https://martinctc.github.io/blog/images/Rlogo.png" width="30%" style="float:left; padding:10px" /></p>
<p><strong>That’s interesting, especially that you were motivated by an application of analytics in politics, as opposed to physics! Tell me about when you were first introduced to R - did you come across this during your degree? Did you have any prior background in programming?</strong></p>
<p>I started learning with the traditional approach first, and then started with with the <a href="https://www.tidyverse.org/">tidyverse</a>. This made me realize the difference between the two and how one can achieve same outcome using multiple methods. In the traditional approach, I always think in terms of what data type this function is going to provide me - e.g. whether it’ll be a logical array, or an index. This helps to decide how to nest the functions. Whilst with the tidyverse approach, I imagine what each verb does to the dataset, and then how to process the chain of sequence using the <a href="https://magrittr.tidyverse.org/">pipe operator</a>. Learning R has been fun for me since I can obtain the same outcome using multiple ways!</p>
<p><strong>That’s super interesting, and chimes with my own experience with learning R, i.e. starting with base, then discovering tidyverse, and then learning data.table for tasks that are more performance-demanding.</strong></p>
<p>So true. <a href="https://github.com/Rdatatable/data.table/wiki">data.table</a> is so performance savvy.</p>
<div id="day-to-day-use-of-r" class="section level3">
<h3>Day to day use of R</h3>
<p><strong>I always find it very interesting how people use R in very different ways. I personally started using R for its text mining capabilities, and certainly some people use R for other things like web-scraping or even making memes (!). What do you use R for on the day to day? What packages do you use, apart from the obvious ones (tidyverse)?</strong></p>
<p>In my day to day life, I use R for everything starting from data cleaning, visualization, data wrangling, and to create models! I use <a href="https://ggplot2.tidyverse.org/">ggplot2</a>, <a href="http://topepo.github.io/caret/index.html">caret</a>, <a href="https://cran.r-project.org/web/packages/timeSeries/index.html">timeSeries</a> (for timeseries) apart from the usual ones.</p>
<p><img src="https://martinctc.github.io/blog/images/MSExcel.png" width="30%" style="float:left; padding:10px" /></p>
</div>
<div id="r-vs-excel" class="section level3">
<h3>R vs Excel</h3>
<p><strong>One thing that people talk a lot about is whether languages like R and Python would displace or replace “traditional” tools like Excel. What’s your take on this subject?</strong></p>
<p>That’s a great question. I previously worked on a project where we were using Excel for data cleaning processes like removing spaces between words, replacing empty cells with 0, and so on. This wasn’t just for 1 file, but we were doing this for around 20 such files. And the time it would take for such a task would be immense for each file to just replace the blank values with 0s. It would mainly depend on the number of rows and columns, but we had to spare 2-3 days for this task alone every month. At that time, I was learning R and decided to use it to do these simple tasks. Though it took me some time for me to code and then to debug the code, I am glad I did it. It is still being used by the team, and have saved us many hours.</p>
<p>However, I don’t believe that R and Python can displace Excel in general field. In data science, it may. In general, Business stakeholders who have minimal understanding of programming love spreadsheets, and it will be very difficult for R to displace that.</p>
<p><strong>I’m inclined to agree with you. People talk a lot about Excel being “dead”, but actually if you think about it, there are many uses for Excel which isn’t straightforward data analysis. For instance, data entry, ad-hoc cost estimations where you need to “play around” with combinations, creating dashboards which are fully portable and which you can run anywhere and send via email, etc. This portability thing is quite important, because in the real world things like IT restrictions or internet access can be a real barrier to socialising an interactive dashboard output like Shiny. Moreover, I think Excel will still be popular because it’s neither realistic nor efficient to expect stakeholders to be able to read code or to run code on their own.</strong></p>
</div>
<div id="the-evolving-capabilities-of-r" class="section level3">
<h3>The evolving capabilities of R</h3>
<p><strong>I also love your example about using R for its automation value. My own personal motivation for learning to code was actually to automate tedious and repetitive tasks, which was why I started off learning Excel VBA. That was before I discovered R of course! I now even use R for PowerPoint automation, using packages such as David Gohel’s <a href="https://github.com/ardata-fr/mschart">mschart</a> and <a href="https://davidgohel.github.io/officer/">officer</a>, just to save myself the pain from and the potential errors that arise from creating loads and loads and loads of PowerPoint slides. I’ve heard that nowadays you can use RMarkdown to generate PowerPoint slides, but I haven’t quite looked into this yet.</strong></p>
<p>I love how R is evolving year over year, and things are getting simplified. Recently I was watching a presentation from Joe Cheng (CTO at RStudio) where he talks about <a href="https://speakerdeck.com/jcheng5/shiny-in-production">his work about Plot Caching in RShiny App</a>. It is good to know that there is an entire community who is working to make things better than they are today.</p>
</div>
<div id="staying-on-top-of-r-developments" class="section level3">
<h3>Staying on top of R developments</h3>
<p><strong>I guess the other thing that I’m quite interested in finding out about is the R community in which you’re based. In London, we have these regular R user meet-ups and conferences, and in general the community is very diverse and welcoming. What is it like in Bangalore? Do you have many meet ups locally, or do you usually get information about these things online?</strong></p>
<p>There are many meet-ups happening in Bangalore. I believe they are great places to learn from each other, but unfortunately I haven’t been able to participate in such meetups. And hence my knowledge I get is from <a href="https://www.r-bloggers.com/">r-bloggers</a> which I have subscribed to get daily dose of knowledge.</p>
<p><strong>Ah, that I can empathise - I’ve learnt so much from reading user contributions on r-bloggers myself. Thank you for the really interesting and informative chat, Abhishek. Finally, to wrap things up - have you got any personal tips or advice on learning R or data science for new-comers hoping to enter the industry?</strong></p>
<p>My advice to the people starting out is to start using R in practical application and not just limited to courses. Once you start using R, the entire R community will be there to help you out!</p>
<p><strong>Awesome, I totally agree. Thanks again Abhishek for sharing your experience and insights, I really enjoyed this chat!</strong></p>
</div>
<div id="end-notes" class="section level3">
<h3>End Notes</h3>
<p>If you enjoyed this post, you might also like <a href="https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/">this other post in my “Data Chats” series</a>, where I spoke with Avision Ho, a Senior Data Scientist in the UK Government.</p>
<p>There will be more of these “Data Chats” coming in the future. If you’d like to share your experience or an interesting project that you’re working on, I would definitely love to hear from you - in which case please leave me a message below!</p>
</div>
</div>
</section>
