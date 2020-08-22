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
We built an R Shiny app to improve access to information on Hong Kong's local politicians. This is so that voters can make more informed choices. This combines information on each politician alongside their Facebook updates and illustrative maps of their district.

> *This project is an attempt to help make a difference with R programming. It's an opportunity for us to learn, to code, to have fun, and to make a difference.*

## Overview
Our project was mainly motivated by one observation: that there is a significant barrier in accessing updates from local politicians in Hong Kong. Historically, the work of district councillors are neither widely known nor closely held to account, and most did not use webpages or Facebook pages to share their work. 

In this project, we tackled this problem by creating a Shiny app in R, which brings together the Facebook feeds and constituency information for Hong Kong's district councillors in one place. In this way, people will have access to this disparate information in a web app.

You can access:

- The app [here](https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/). 
- Our GitHub repository [here](https://github.com/avisionh/dashboard-hkdistrictcouncillors). 
- Don't forget to also provide some feedback to the Shiny app [here](https://hkdistrictsinfo.typeform.com/to/gFHC02gE)!

Whether you are more of an R enthusiast or simply someone who has an interest in Hong Kong politics (hopefully both!), we hope this post will bring you some inspiration on how you can use R _not just_ as a great tool for data analysis, but also as an enabler for you to do something tangible for your community and contribute to causes you care about. 

## Why develop this app?
There are heightened levels of political engagement in Hong Kong in the recent years, which is leading to a surge in demand for information and knowledge about how people can make a difference. 

The District Council is the most local level of government in which people can influence change.

## Who is behind this?
- Avision Ho, a data scientist whom I had [previously interviewed.](https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/)
- Ocean
- Justin
- Tiffany

## What is in the app?

The Shiny app is built like a dashboard which combines information about each district councillor alongside their Facebook page posts (if it exists) and the district they serve, illustrated on an interactive map.

Specifically, there are several key components that were used on top of the incredible [shiny](https://github.com/rstudio/shiny) package:

- [shinydashboard](https://github.com/rstudio/shinydashboard): For mobile-friendly dashboard layout.
    + We understood that our users, primarily HK citizens, frequently use mobiles. Thus, to ensure this app was useful to them, we centred our design on how the app looked on their mobile browsers.
    
- [googlesheets4](https://github.com/tidyverse/googlesheets4): For seamless access to GoogleSheets.
    + We understood that our users are not all technical so we stored the core data in a format and platform familiar and accessible to most people, Google Sheets.
    
- [sf](https://github.com/r-spatial/sf) and [leaflet](https://github.com/rstudio/leaflet): For importing geographic data and creating interactive maps.
    + We understood that our users may want to explore other parts of Hong Kong but may not know the names of each constituency. Thus, we provided a map functionality to improve the ease they can learn more about different parts of Hong Kong.

- [rintrojs](https://github.com/carlganz/rintrojs): For interactive tutorials.
    + We understood that our users are not necessarily keen to read pages of instructions on how to use the app, especially if they are on mobile. Thus, we implemented a dynamic feature that walks them through visually each component of the app.

## How was the data collected?

<Insert screenshot>

- Data on each district councillor, their constituency, the party they belong to and their Facebook page was all collected manually through a combination of Wikipedia and Facebook.
    + We kept the data outside of the repo to keep the memory size small.
    + Stored it in GoogleSheets so non-technical users can access the data too.
- Data on each district councillors contact details were web-scraped from ...
- Boundaries for each constituency were obtained through a Freedom of Information (FOI) request by a member of the public [here](https://accessinfo.hk/en/request/shapefileshp_for_2019_district_c).

### Creating a data package
From sharing our project with friends, we were approached to help with another project to visualise Hong Kong traffic collisions data, repo is [here](https://github.com/Hong-Kong-Districts-Info/hktrafficcollisions). As part of this, we obtained this data via an FOI request on traffic collisions. In the interests of open-source, we developed an R package, [hkdatasets](https://github.com/Hong-Kong-Districts-Info/hkdatasets) that stores these datasets, all themed around Hong Kong.

### Linking to Facebook
<Insert screenshot>
- Talk about challenges of getting the Facebook API
- Found a workaround using just iframes - expedient but fit-for-purpose

### Visualising the shapefiles 

<Insert screenshot>

> The first rule of optimisation is you don't.
>
> --- *Michael A. Jackson*

- To rapidly get a Proof of Concept up using the shapefiles, we created a static ggplot map.
- This was to quickly visualise the districts and how they look in relation to the Shiny app.
- Once we settled on how the map looked in relation to the Shiny app, we then spent some additional time and effort to investigate using [leaftet](https://github.com/rstudio/leaflet)
- We moved to `leaflet` maps because of their interactivity. 
     + We understood our users would want to explore the HK map interactively to find out what consituency they belong to or to find out one that was of interest. This was because we were aware that people may know what region they live in but they may not know the name of the consituency.

## What are our next steps?
- Some cool stuff we have not been able to implement:

    + [precommit hooks](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/17): Those familiar with Python may be aware of pre-commit hooks as ways to automatically detect whether your repo contains anything sensitive like a `.secrets` file. Setting this up will enable us to have automated checks run each time we make a commit to assure we are follow specified standards.
    + [codecov](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/33): Allows us to robustly test the functions in our code so that they work under a multitude of scenarios such as when users encounter problems.
    + [modularise shiny code](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/26): Ensures our Shiny code is more easier to follow.
    + [language selection](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/36): Currently the app is a smorgasbord of English and Chinese. Consequently, it looks messy. We want to implement the ability for the user to choose which language they want to see the app in and the app's language will update accordingly.
    + Release to alpha testers to get early feedback.
    
## Want to get involved?
- Be a 'reviewer' or help with coding
- Send an email to hkdistricts.info@gmail.com