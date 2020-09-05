---
title: "A Shiny app on Hong Kong District Councillors"
author: "Martin Chan, Avision Ho"
date: "August 31, 2020"
output:                    # DO NOT CHANGE
  prettydoc::html_pretty:  # DO NOT CHANGE
    theme: cayman          # DO NOT CHANGE
    highlight: github      # DO NOT CHANGE
---

# 👀 TL;DR

We built an [R Shiny app](https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/) to improve access to information on Hong Kong's local politicians. This is so that voters can make more informed choices. The app shows basic information on each politician, alongside a live feed of their Facebook page and illustrative maps of their district.

> *This project is an attempt to help make a difference with R programming. It's an opportunity for us to learn, to code, to have fun, and to make a difference.*

This blog post is originally published on https://martinctc.github.io/blog/, and co-authored by Martin Chan and Avision Ho.

## 💻 Overview
Our project was mainly motivated by an observation **that the engagement of the Hong Kong public with their local politicians is very low.**[^1] Historically, the work of Hong Kong's District Councillors (DCs) are neither widely known nor closely scrutinised by the public media. Until recently, most District Councillors did not use webpages or Facebook pages to share their work, but instead favour distributing physical copies of 'work reports' via Direct Mail. A hypothesis is that this has changed significantly with the 2019 District Council election, where turnout has jumped to 71% (from 47% in 2015). For context, Hong Kong's District Councils is the most local level of government, and is the only level in which there is full universal suffrage for all candidates.

<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/18-district-council.png" alt="A map of Hong Kong's 18 District Councils. Illustration by Ocean Cheung" style="max-width:300px;">

[^1]: There are many reasons for this, and arguably a similar phenomenon can be observed in most local elections in other countries. See Lee, F. L., & Chan, J. M. (2008). Making sense of participation: The political culture of pro-democracy demonstrators in Hong Kong. *The China Quarterly*, 84-101.

As of the summer of 2020, we identified that 96% (434) of the 452 District Councillors elected in 2019 actually have a dedicated Facebook page for delivering updates to and engaging with local residents. However, these Facebook pages have to be manually searched for online, and there is not a readily available tool where people can quickly map a District to a District Councillor and to their Facebook feeds. 

As a wise person once said, "If you can solve a problem effectively in R, why the hell not?" We tackled this problem by creating a Shiny app in R, which brings together the Facebook feeds and constituency information for Hong Kong's district councillors in one place. In this way, people will be able to access the currently disparately stored information in a single web app.

You can access:

- The Shiny app [here](https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/). 
- Our GitHub repository [here](https://github.com/avisionh/dashboard-hkdistrictcouncillors/). 
- Don't forget to also provide some feedback to the Shiny app [here](https://hkdistrictsinfo.typeform.com/to/gFHC02gE)!

Whether you are more of an R enthusiast or simply someone who has an interest in Hong Kong politics (hopefully both!), we hope this post will bring you some inspiration on how you can use R _not just_ as a great tool for data analysis, but also as an enabler for you to do something tangible for your community and contribute to causes you care about. 

## 🔍 What is in the app?

<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/hkdc-app-example.png" width=500>

The Shiny app is built like a dashboard which combines information about each district councillor alongside their Facebook page posts (if it exists) and the district they serve, illustrated on an interactive map. By using the District and Constituency dropdown lists, you can retrieve information about and the Facebook feed of the District Councillor of the selected Constituency.

Specifically, there are several key components that were used on top of the incredible [shiny](https://github.com/rstudio/shiny) package:

- [shinydashboard](https://github.com/rstudio/shinydashboard): For mobile-friendly dashboard layout.
    + We understood that our users, primarily HK citizens, frequently use mobiles. Thus, to ensure this app was useful to them, we centred our design on how the app looked on their mobile browsers.
    
<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/googlesheets4.png" width=200>
   
- [googlesheets4](https://github.com/tidyverse/googlesheets4): For seamless access to Google Sheets.
    + We understood that our users are not all technical so we stored the core data in a format and platform familiar and accessible to most people, Google Sheets.
    + At a later stage of the app development, we migrated to storing the data in an R package we wrote, called [**hkdatasets**](https://github.com/hong-Kong-Districts-Info/hkdatasets) as we sought to keep the data in one place. However, the Google Sheets implementation worked very well, and the app could be deployed with no impact on performance or user experience.
    
- [sf](https://github.com/r-spatial/sf) and [leaflet](https://github.com/rstudio/leaflet): For importing geographic data and creating interactive maps.
    + We understood that our users may want to explore other parts of Hong Kong but may not know the names of each constituency. Thus, we provided a map functionality to improve the ease they can learn more about different parts of Hong Kong.

- [rintrojs](https://github.com/carlganz/rintrojs): For interactive tutorials.
    + We understood that our users are not necessarily keen to read pages of instructions on how to use the app, especially if they are on mobile. Thus, we implemented a dynamic feature that walks them through visually each component of the app.

## 🗄️ How was the data collected?

Since there was no existing single data source on the DCs, we had to put this togther ourselves. All the data on each District Councillor, their constituency, the party they belong to, and their Facebook page was all collected manually through a combination of Wikipedia and Facebook. The data was initially housed on Google Sheets, for multiple reasons: 

1. Using Google Sheets made it easy for multiple people to collaborate on data entry.
2. Keeping the data outside of the repo has the advantage of keeping the memory size minimal, in line with best practices.
3. By storing the data in Google Sheets, non-technical users would also be able to access the data too.

Most of all, it was easy to access the Google Sheets data with the {googlesheets4} package! For editing the data for _pre-processing_, a key function is `googlesheets4::gs4_auth()`, which directs the developer to a web browser, asked to sign in to their Google account, and to grant googlesheets4 permission to operate on their behalf with Google Sheets. We then set up the main Google Sheet - the nicely formatted version intended for the app to ingest - to provide read-only access to anyone with the link, and used `googlesheets4::gs4_deauth()` to access the public Google Sheet in a _de-authorised_ state. The Shiny app itself does not have any particular Google credentials stored alongside it (which it shouldn't, for security reasons), and this workflow allows  (i) collaborators/developers to edit the data from R and (ii) for the app to access the Google Sheet data without any need for users to login.

This Google Sheet is available [here](https://docs.google.com/spreadsheets/d/1007RLMHSukSJ5OfCcDJdnJW5QMZyS2P-81fe7utCZwk/).

<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/googlesheet-example.png" width=500>

Creating a map with constituency boundaries also required additional data. Boundaries for each constituency were obtained through a Freedom of Information (FOI) request by a member of the public [here](https://accessinfo.hk/en/request/shapefileshp_for_2019_district_c).

This was pretty much Phase #1 of data collection, where we had single Google Sheet with basic information about the District Councillors and their Facebook feeds, which enabled us to create a proof of concept of the Shiny app, i.e. making sure that we can set up a mechanism where the user can select a constituency and the app returns the corresponding Facebook feed of the District Councillor.

Based on user feedback, we started with Phase #2 of data collection, which involved a web-scraping exercise on the official [Hong Kong District Council website](https://www.districtcouncils.gov.hk/index.html) and the [HK01 News Page on the 2019 District Council elections](https://dce2019.hk01.com/) to get extra data points, such as:
- Contact email address
- Contact number
- Office address
- Number of votes, and share of votes won in 2019

A function that was extremely helpful for figuring out the URL of the District Councillors' individual official pages is the following. What this does is to run a Bing search on the https://www.districtcouncils.gov.hk website, and scrape from the search result any links which match what we want (based on what the URL string looks like). Although this doesn't always work, it helped us a long way with the 452 District Councillors.

```
scrape_dcs <- function(search_term){
  
  query_string <- paste("site: https://www.districtcouncils.gov.hk", search_term)
  
  squery <- URLencode(query_string)
  
  squeryfull <- paste0("https://www.bing.com/search?q=", squery)
  
  main_page <- xml2::read_html(squeryfull)
  
  temp <- html_nodes(main_page, '.b_title a') %>%
    html_attr("href")
  
  temp[grepl("member_id=", temp)]
}
```
One key thing to note is that all of the above data we compiled is available and accessible in the public domain, where we simply took an extra step to improve the accessibility.[^2] The Phase #2 data was used in the final app to provide more information to the user when a particular constituency or District Councillor is selected.

[^2]: This is in compliance with the ICO's description of the 'public domain', i.e. that _information is only in the public domain if it is realistically accessible to a member of the general public at the time of the request. It must be available in practice, not just in theory_.

### 📦 Creating a data package

Our data R package, [**hkdatasets**](https://github.com/hong-Kong-Districts-Info/hkdatasets), is to some extent a spin-off of this project. We decided to migrate from Google Sheets to an R data package approach, for the following reasons: 

- An R data package could allow us to provide more detailed documentation and tracking of how the data would change over time. If we choose to expand the dataset in the future, we can easily add this to the package release notes.

- An R data package would fit well with our broader ambition to work on other Hong Kong themed, open-source projects. From sharing our project with friends, we were approached to help with another project to visualise Hong Kong traffic collisions data, where the repo is [here](https://github.com/Hong-Kong-Districts-Info/hktrafficcollisions). As part of this, we obtained this data via an FOI request on traffic collisions, where the data is also available through **hkdatasets**.

- Make it easier for learners and students in the R community to practise with the datasets we've put together, without having to learn about the **googlesheets4** package. Our thinking is that this would benefit others as other data packages like **nycflights13** and **babynames** have benefitted us as we learned R.

**hkdatasets** is currently only available on GitHub, and our aim is to release it on CRAN in the future so that more R users to take advantage of it. Check out our  [GitHub repo](https://github.com/hong-Kong-Districts-Info/hkdatasets) to find out more about it.

<img src="https://raw.githubusercontent.com/martinctc/blog/master/images/hkdatasets-hex.png" width=200>

### Linking our Shiny App to Facebook
<Insert screenshot>

When we first conceptualised this project, our aim has always been to make the Facebook Page content the centre piece of the app. This was contingent on using some form of Facebook API to access content on the District Councillors' Public Pages, which we initially thought would be easy as Public Page content is 'out there', and shouldn't require any additional permissions or approvals. 

It turns out, in order to read public posts from Facebook Pages that we do not have admin access to requires a certain permission called **Page Public Content Access**, which in turn requires us to submit our app to Facebook for review. Reading several threads (such as [this](https://developers.facebook.com/community/threads/385801828797027/)) online soon convinced us that this would be a fairly challenging process, as we need to effectively submit a proposal on why we had to request this permission. To add to the difficulty, we understood that the App Review process had been put on pause at the time, due to the re-allocation of resourcing during COVID-19. 

This drove us to search for a workaround, and this is where we stumbled across _iframes_ as a solution. An _iframe_ is basically a frame that enables you embed a HTML document within another HTML document (they've existed for a long time, as I recall using them in the really early GeoCities and Xanga websites). 

The `iframe` concept roughly works as follows. All the Facebook Page URLs are saved in a vector called `FacebookURL`, and this is "wrapped" with some HTML markup that enables it to be rendered within the Shiny App as an UI component (using `shiny::uiOutput()`:  
```
chunk1 <- '<iframe src="https://www.facebook.com/plugins/page.php?href='
chunk3 <- '&tabs=timeline&width=400&height=800&small_header=false&adapt_container_width=true&hide_cover=false&show_facepile=true&appId=3131730406906292" width="400" height="800" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true" allow="encrypted-media"></iframe>'
iframe <- paste0(chunk1, FacebookURL, chunk3)
```
Although the `iframe` solution comes with its own challenges, such as the difficulty in making it truly responsive / mobile-optimised, it was nonetheless an expedient and effective workaround that allowed us to produce a proof-of-concept; the alternative was to splash around in Facebook's API documentation and discussion boards for at least another month to achieve the App Approval (bearing in mind that we were working on this in our own free time, with limited resources).

### Visualising the shapefiles 

<Insert screenshot>

> The first rule of optimisation is you don't.
>
> --- *Michael A. Jackson*

We acquired shapefiles in order to be able to visualise the individual Disticts on a map. A shapefile is, according to [the ArcGIS website](https://desktop.arcgis.com/en/arcmap/10.3/manage-data/shapefiles/what-is-a-shapefile.htm):

> ... a simple, nontopological format for storing the geometric location and attribute information of geographic features. Geographic features in a shapefile can be represented by points, lines, or polygons (areas).

To rapidly get a Proof of Concept up using the shapefiles, we created a static ggplot map with `geom_sf()` from **ggplot2**. This was to quickly visualise the districts and how they look in relation to the Shiny app.

![](https://user-images.githubusercontent.com/25527485/88489291-6891a280-cf8b-11ea-8c0e-eb48a5af5094.png)
(Image shows an earlier iteration of the app)

The code we used was as follows:
```
map_hk_districts <- ggplot() +
  geom_sf(data = shape_hk, fill = '#009E73') +
  geom_sf(data = shape_district, fill = '#56B4E9', alpha = 0.2, linetype = 'dotted', size = 0.2)
```  

- Once we settled on how the map looked in relation to the Shiny app, we then spent some additional time and effort to investigate using [leaflet](https://github.com/rstudio/leaflet)
- We moved to `leaflet` maps because of their interactivity. 
     + We understood our users would want to explore the HK map interactively to find out what consituency they belong to or to find out one that was of interest. This was because we were aware that people may know what region they live in but they may not know the name of the consituency.

## What are our next steps?

There were some cool features that we would have liked to, but have not been able to implement:  

- [precommit hooks](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/17): Those familiar with Python may be aware of pre-commit hooks as ways to automatically detect whether your repo contains anything sensitive like a `.secrets` file. Setting this up will enable us to have automated checks run each time we make a commit to assure we are follow specified standards.
    + Unfortunately, we named our repo with a hyphen so the pre-commit hooks won't work.
    + [codecov](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/33): Allows us to robustly test the functions in our code so that they work under a multitude of scenarios such as when users encounter problems.
- [modularise shiny code](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/26): Ensures our Shiny code is more easier to follow.
- [language selection](https://github.com/Hong-Kong-Districts-Info/dashboard-hkdistrictcouncillors/issues/36): Currently the app is a smorgasbord of English and Chinese. Consequently, it looks messy. We want to implement the ability for the user to choose which language they want to see the app in and the app's language will update accordingly.
- Release to alpha testers to get early feedback.

One of the things that we wanted to try out with this open-source project is to adhere to some DevOps best practices, yet unfortunately some of these were either easier to set up from the beginning, or require more time and knowledge (on our part) to set up. As we develop a V2 of this Shiny App and work on [other projects](https://hong-kong-districts-info.github.io/portfolio/), we hope to find the opportunity to implement more of the above features.
    
## Who is behind this?

Multiple people contributed to this work. **Avision Ho** is a data scientist who wrote the majority of the Shiny app, and who was also [previously interviewed on this blog](https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/). Avision is a co-author on this post. **Ocean Cheung** came up with the original idea of this app, and made it all possible with his knowledge and network with District Councillors. We would also like to credit **Justin Yim**, **Tiffany Chau**, and **Gabriel Tam** for their 
feedback and advice on the scope and the direction of this app. We are currently working on a number of other projects, which you can find out more from our website: https://hong-kong-districts-info.github.io/.

(Disclaimer! We are not affiliated to any political individuals nor movements. We are simply some people who'd like to contribute to society through code and open-source projects.)
    
## Want to get involved?
- Be a 'reviewer' or help with coding
- Send an email to hkdistricts.info@gmail.com
