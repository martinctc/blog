## Data Chats: From Physics student to Analytics Consultant

## Introduction

How do you begin a career in analytics and data science? How do you learn R? 

These are interesting questions that everyone has different answers to. This week, I have the pleasure of speaking with Abhishek Modi, to find out about his journey from a Physics student to an Analytics Consultant at Deloitte. 

### About Abhishek

Abhishek is a Data Science consultant for Deloitte and has experience in this domain of 4 years. He decided to go in this direction after graduating from National Institute of Technology, Surat with a master degree in Physics. Abhishek has worked with Fortune 100 companies to help their IT, Sales, and Marketing teams with data-driven decision using advanced analytics.

## Interview with Abhishek Modi

##### To start, could you tell me a bit about what you currently do, and what is your background?

I did Bachelors and Masters in Physics where my interest was in the design of particle accelerators and even my master thesis was on the same! During the dissertation period, I explored a lot of fields within and outside Physics. During this time, I came across FiveThreeEight and was surprised at how accurate predictions were made in 2008 US elections. This led to my desire to interview for data analytics companies at an entry level and soon I got an offer from one.

Now after 4 years, I am working as a Consultant for Deloitte in their Analytics and Cognitive team based in Bangalore, India. My toolbox containts R, SQL, and Excel for 99% of the tasks.

<img src="https://martinctc.github.io/blog/images/Rlogo.png" alt="drawing" width="30%" style="float:left"/>

##### That’s interesting, especially that you were motivated by an application of analytics in politics, as opposed to physics! Tell me about when you were first introduced to R - did you come across this during your degree? Did you have any prior background in programming?

I started learning with the traditional approach first and then started with with the tidyverse. This made me realize the difference between the two and how one can achieve same outcome using multiple outcomes. In the traditional approach, I always think in terms of what data type this function is going to provide me whether logical array, or an index. This helps to decide how to nest the functions.
While with tidyverse output, I imagine what each verb does to the dataset and then how to process the chain of sequence using the pipe operator.

Learning R has been fun for me since I can obtain the same outcome using multiple ways!

##### That’s super interesting, and chimes very well with my own experience with learning R, i.e. starting with base, then discovering tidyverse, and then learning data.table for tasks that are more performance-demanding.

##### I always find it very interesting how people use R in very different ways. I personally started using R for its text mining capabilities, and I know some people for web-scraping. What do you use R for on the day to day? What packages do you use, apart from the obvious ones (tidyverse)?

So true. **data.table** is so performance savvy.

In my day to day life, I use R for everything starting from data cleaning, visualization, data wrangling, and to create models! I use **ggplot2**, **caret**, **ts** (for timeseries) apart from the usual ones.

<img src="https://martinctc.github.io/blog/images/MSExcel.png" alt="drawing" width="30%" style="float:left"/>

##### One thing that people talk a lot about is whether languages like R and Python displace “traditional” tools like Excel. What’s your take on this subject?

That's a great question. I was working on a project where we were using Excel for data cleaning processes like removing spaces between words, replacing empty cells with 0 and so on.  Not just for 1 file but were doing this for around 20 such files and the time it would take for such a task would be around for each file to just replace the blank value with 0.  It would mainly depend on the number of rows and columns but we had to spare 2-3 days for this task alone every month. At that time I was learning R and decided to use it to do these simple tasks. Though it took me some time for me to code and then to debug the code I am glad I did it. It is still being used by the team and have saved many hours.

However, I don't believe that R and Python can displace Excel in general field. In data science, it may. In general, Business stakeholders who have minimal understanding of programming love spreadsheets and it will be very difficult for R to displace that.

##### I'm inclined to agree with you. People talk a lot about Excel being "dead", but actually if you think about it, there are many uses for Excel which isn't straightforward data analysis. For instance, data entry, ad-hoc cost estimations where you need to "play around" with combinations, creating dashboards which are fully portable and which you can run anywhere and send via email, etc. This portability thing is quite important, because in the real world things like IT restrictions or internet access can be a real barrier to socialising an interactive dashboard output like Shiny. Moreover, I think Excel will still be popular because it's neither realistic nor efficient to expect stakeholders to be able to read code or to run code on their own. 

##### I also love your example about using R for its automation value. My own personal motivation for learning to code was actually to automate tedious and repetitive tasks, which was why I started off learning Excel VBA. That was before I discovered R of course! I now even use R for PowerPoint automation, using packages such as David Gohel's mschart and officer, just to save myself the pain from and the potential errors that arise from creating loads and loads and loads of PowerPoint slides. I've heard that nowadays you can use RMarkdown to generate PowerPoint slides, but I haven't quite looked into this yet.

I love how R is evolving year over year and things are getting simplified. Recently I was watching a presentation from Joe Cheng (CTO at RStudio) where he talks about his work about Plot Caching in RShiny App. It is good to know that there is an entire community who is working to make things better than they are today

##### I guess the other thing that I'm quite interested in finding out about is the R community in which you're based. In London, we have these regular R user meet-ups and conferences, and in general the community is very diverse and welcoming. What is it like in Bangalore? Do you have many meet ups locally, or do you usually get information about these things online?

Though there are many meetups happening in Bangalore. I believe they are great places to learn from each other but unfortunately I haven't been able to participate in such meetups. And hence my knowledge I get is from r-bloggers which I have subscribed to get daily dose of knowledge.

#### Ah, that I can empathise - I've learnt so much from reading user contributions on r-bloggers myself. Thank you for the really interesting and informative chat, Abhishek. Finally, to wrap things up - have you got any personal tips or advice on learning R or data science for new-comers hoping to enter the industry?

My advice to the people starting is out is to start using R in practical application and not just limited to courses. Once you start using R, the entire R community will be there to help you out!

#### Awesome, I totally agree. Thanks again Abhishek for sharing your experience and insights, I really enjoyed this chat!

### End Notes

I'll be doing more of these 'Data Chats' in the future. If you'd like to share your experience or an interesting project that you're working on, please leave me a message below! 
