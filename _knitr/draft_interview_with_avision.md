# Data Chats: An Interview with Avision Ho

## Introduction

### Why do an interview?

On this occasion, I've decided to have a conversation with a data scientist for a change, as opposed to creating a vignette or reviewing a package (atypical of the content [on this blog](https://martinctc.github.io/blog/)). I've always enjoyed interviews as talking to people is a great way to understand and imagine *what it really is like* to do something, or face a particular challenge. Hope you all enjoy this interview!

### About Avision

<img src="https://martinctc.github.io/blog/images/avision-profile.jpeg" alt="drawing" width="200"/>

I've decided to have a conversation with Avision Ho, who's a data scientist and also a **tidyverse** enthusiast whom I've met at a R conference in London. Avision works as a data scientist at the UK Government's Department of Education, and has a background in Economics and Mathematics. Nowadays, Avision mainly spends his time creating robust data pipelines that feed the data from an external body's API into SQL databases; establish and implement strong data management and handling principles; and advising colleagues and clients on how to effectively use the data. If you wish to find out more about him, check out [his GitHub profile here](https://github.com/avisionh).

One reason why I thought it'd be interesting to speak with Avision is because he will be speaking at the [EARL Conference this upcoming September in London](https://earlconf.com/). From my own experience, speaking about a technical subject at a conference can be both intimidating and enjoyable, so in this interview I'm going to find out what he is talking about and what his experience of the process is like.

### EARL Conference

<img src="https://martinctc.github.io/blog/images/earl-logo.png" alt="drawing" width="200"/>

The EARL Conference is an annual conference on the *Enterprise Applications of the R Language*, organised by Mango Solutions. My friend Avision is giving a talk in the upcoming EARL 2019 in September in London, so in this interview we had a chat about what's it all going to be about.

**Disclaimer**: I'm not affiliated with Mango Solutions! I have however found the EARL conference and other meet-ups (e.g. LondonR) they organise to be extremely helpful. Through their talks/events I've made many friends (including Avision), and certainly have expanded my knowledge in R. Talking to people is a great way to learn - an approach I'd much prefer over simply binge-ing on R video tutorials!


## Interview with Avision Ho

**Do you want to start off by telling me briefly what your EARL talk is about? I seem to recall it had something to do with Nobel Prizes.**

Certainly, the title of the talk is: "*Why a Nobel Prize algorithm is not always optimal for business*".

The title of it was quite deliberate in ensuring that it was as click-bait-y as possible and in many respects, it focusses the mind on the actual issue that we face day-to-day as data scientists. Specifically, that a Nobel-Prize algorithm may be the most fastest and accurate solution to a problem, but when you have business constraints such as cost, computing power or even time, then sometimes, the best and optimal solution is one that's more low-tech but achieves a better balance in these constraints.

**Well I think a click-bait is perfectly acceptable when you're delivering a data science talk - most people do it. I'm actually slightly surprised you didn't try to slip a R pun in there! What inspired you to choose this subject to talk about?**

Haha, I think there have already been many R puns used out there such that using one may lose its desired effect!

Regarding inspiration, it was inspired by a recent project I volunteered for in helping to organise a conference.
As part of the conference, my team's responsibility was to assign attendees to talks that are occurring simultaeously, given that the attendees have revealed preferences over which talks they want to attend. Breaking down the issue in this way enabled me to recognise that this must be an issue that was tackled before because it is quite a common one. Upon searching on the internet, lo and behold, I found research in the game theoretical discipline that did cover this problem.

Yet as I implemented it, I realised that there were two core issues with this initial solution:
1. *Scalability* - the particular implementation that I was using would quickly slow down for larger datasets which wasn't an issue for the dataset I was using, but would be if it was applied to other ones.
2. *Interpretability* - the algorithm I was using was theoretically sound and mathematically robust but it was difficult to explain and understand in a 30 second window, which was something important as I wanted to make the selection process as transparent as possible for attendees.

This led me on a merry chase to build my own bespoke function/algorithm solved these two issues.

Whilst I make no claim to this solution being as theoretically sound nor mathematically robust as the initial solution (which did win the Nobel Prize), so sadly I am not expecting an invite to next year's ceremony; it did fit our business needs better.

Therefore, this talk was based off the experiences I had on this project. What I plan to cover in my talk also is turning a process that requires coding knowledge to a process which is knowledge-agnostic. By this I mean that I won't be volunteering for that conference next year nor at other time soon, so I will cover the second phase of it where I future-proofed what I did so that whoever takes over is able to use what I built, irrespective of whether they can code or not.

**Wow that sounds super fascinating. In danger of making you give the entire plot  of your talk away before you actually deliver it - I presume you implemented all of your solution in R? Was there a reason why you chose R to do this?**

Haha, maybe I just talk too much! As it is, my solution was implemented all in R. I chose it because I am most familiar with R and there isn't a strict requirement to use other languages.

Nevertheless, I do want to link the app to an underlying SQL database so that I do not need to store the dummy data within the app session. The part I have not quite got my head round is finding a vendor who will offer me a free cloud SQL database.

**That makes sense. I guess what I'm trying to get at, more broadly, is understanding is how R fits within the broader suite of tools and languages that you use in your day-to-day work.** 

Absolutely, I use the following tools for the specific purposes:

1. SQL (SSMS specifically) - storing and manipulating data
2. Visual Studio - building SSIS packages to import data into SQL
3. R - analysis, sharing analysis, apps building
4. Git - version-control
5. Python - analysis, sharing analysis to a technical audience, CRUD operations into MongoDB NoSQL database

Regarding things I prefer using R for, they are:

I. **Creating reproducible work**: through RProjects, packrat/renv, RMarkdown, integrated Git in RStudio (though I am a Git Bash fanboy) as well as the well-developed framework, the conditions are really strong for me to create projects that can be ported over easily onto a different machine for a colleague to run. 

II. **Communicating analysis to technical and non-technical audiences**:  RMarkdown is really strong here in the way you can weave your commentary relatively seamlessly alongside code and graph outputs. This enables me to create parameterised reports that update automatically when the data is updated. Via the ability to show and hide code instantaneously, the report can easily cater for technical audiences who want to see your code, and non-technical audiences who can be put-off by it.

III. **App building**: this is more debateable, but if I want to relatively quickly create a bespoke web-application such as a dashboard, then I would use R because I know it quite well.

**That's interesting - I'm with you! I personally love RMarkdown as well for the fact it ticks so many boxes - it's great for documentation, for producing professional business outputs, whilst at the same time great for reproducibility. In fact, all my blogs here are written using RMarkdown! Finally, I have two final questions regarding your EARL talk. What is the application process for EARL like for you, and have you got any tips for students who want to get into data science?**

Precisely, absolutely agree with you on all those points. 

Good question on the EARL application. You sound like someone analysing the effectiveness of their process! It was really easy, smooth and quick. Just one relatively short form where you fill in your details, an abstract/description of your talk, a bio of yourself and an accompanying picture. Mango Solutions who determine the speakers then have a read of your abstract and make a decision on that.

Having spoken to Aimee Gott, she said that the key to a successful abstract is emphasising the business element to it. Thus, when I wrote my abstract, I asked myself the following questions:
1. Is it clear that my talk tackled a business problem?
2. How did I go about tackling the business problem?
3. Were there things I did to ensure there were benefits to the business from my solution?

On the second question about tips for students getting into data science, at the very least, it is key that they should have a very inquisitive mind, the ability to independently troubleshoot problems on the internet, and as a bonus, a bit of coding experience. This experience need not even be formal training. Quite often, most data scientists taught themselves how to code, and in actual fact, I think this demonstrates a lot of self drive which is positive!!

**I like your point about self-teaching coding as an evidence of self-drive! I guess the other point to add to that is to self-initiate projects, and be sure to share them either on GitHub or just any code repository so you can demonstrate these attributes you just talked about, such as inquisitiveness and self-drive. Anyway, thanks for the great chat, lots of interesting stuff - and good luck with the talk! **

## Footnotes

Avision's also spoken about his journey to become a Data Scientist from an Economics background. Check out this video interview here, from *Data Strategy with Jonathan*:  
<iframe width="560" height="315" src="https://www.youtube.com/watch?v=x5f6Z0TXdlQ" frameborder="0" allowfullscreen></iframe>

