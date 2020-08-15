---
title: "A Shiny app on Hong Kong District Councillors"
author: "Martin Chan, Avision Ho"
date: "August 31, 2020"
output:                    # DO NOT CHANGE
  prettydoc::html_pretty:  # DO NOT CHANGE
    theme: cayman          # DO NOT CHANGE
    highlight: github      # DO NOT CHANGE
---

## TL;DR
We built an R Shiny app to improve access to information on Hong Kong's local politicians so that voters can make more informed choices. This combines information on each politician alongside their Facebook updates and illustrative maps of their district.

> *This project is an attempt to help make a difference with R programming. It's an opportunity for us to learn, to code, to have fun, and to make a difference.*

## Overview
There is a significant barrier in accessing updates from local politicians in Hong Kong. In this project, we tackled this problem by creating a Shiny app in R, which brings together the Facebook feeds and constituency information for Hong Kong's district councillors in one place. In this way, people will have access to this disparate information in a web app.

You can access:

- The app [here](https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/). 
- Our GitHub repository [here](https://github.com/avisionh/dashboard-hkdistrictcouncillors). 
- Don't forget to also provide some feedback to the Shiny app [here](https://hkdistrictsinfo.typeform.com/to/gFHC02gE)!

Whether you are more of an R enthusiast or simply someone who has an interest in Hong Kong politics (hopefully both!), we hope this post will bring you some inspiration on how you can use R _not just_ as a great tool for data analysis, but also as an enabler for you to do something tangible for your community and contribute to causes you care about. 

## What is the background to this?
There are heightened levels of political engagement in Hong Kong in the recent years, which is leading to a surge in demand for information and knowledge about how people can make a difference. 

The District Council is the most local level of government in which people can influence change.

## Who is behind this?
- Avision Ho, a data scientist whom I had [previously interviewed.](https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/)
- Ocean
- Justin
- Tiffany

## Can we describe the app?

The Shiny app is built like a dashboard which combines information about each district councillor alongside their Facebook page posts (if it exists) and the district they serve, illustrated on an interactive map.

Specifically, there are several key components that were used on top of the incredible [shiny](https://github.com/rstudio/shiny) package:

- [shinydashboard](https://github.com/rstudio/shinydashboard): For mobile-friendly dashboard layout.
- [googlesheets4](https://github.com/tidyverse/googlesheets4): For seamless access to GoogleSheets.
- [sf](https://github.com/r-spatial/sf) and [leaflet](https://github.com/rstudio/leaflet): For importing geographic data and creating interactive maps.
- [rintrojs](https://github.com/carlganz/rintrojs): For interactive tutorials

### Data Collection and Cleaning
<Insert screenshot>
- Where the data came from
- Deliberated to using Google Sheets to avoid bulking up the repo, and also enable participation from those who do not code

### A solution for getting the Facebook feed
<Insert screenshot>
- Talk about challenges of getting the Facebook API
- Found a workaround using just iframes - expedient but fit-for-purpose

### Interactive Map

<Insert screenshot>
- Talk about how we started off dealing with Shape files and a ggplot map, then moved to leaflet
- Challenges and learnings

## What are our next steps?
- Some cool stuff we have not been able to implement:

    + [precommit hooks](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/17): Those familiar with Python may be aware of pre-commit hooks as ways to automatically detect whether your repo contains anything sensitive like a `.secrets` file. Setting this up will enable us to have automated checks run each time we make a commit to assure we are follow specified standards.
    + [codecov](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/33): Allows us to robustly test the functions in our code so that they work under a multitude of scenarios such as when users encounter problems.
    + [modularise shiny code](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/26): Ensures our Shiny code is more easier to follow.

## Want to get involved?
- Be a 'reveiwer' or help with coding
- Send an email to hkdistricts.info@gmail.com

