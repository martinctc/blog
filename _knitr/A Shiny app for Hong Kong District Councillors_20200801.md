---
title: "A Shiny app for Hong Kong District Councillors"
author: "Martin Chan, Avision Ho"
date: "August 31, 2020"
output:                    # DO NOT CHANGE
  prettydoc::html_pretty:  # DO NOT CHANGE
    theme: cayman          # DO NOT CHANGE
    highlight: github      # DO NOT CHANGE
---

## TL;DR
We built an R Shiny app to improve access to information on Hong Kong's local politicians so that voters can make more informed choices. This combines information on each politician alongside their Facebook updates and illustrative maps of their district.

## Overview
There is a significant barrier in accessing updates from local politicians in Hong Kong. In this project, we tackled this problem by creating a Shiny app in R, which brings together the Facebook feeds and constituency information for Hong Kong's district councillors in one place. In this way, people will have access to this disparate information in a web app.

You can access the app [here](https://hkdistricts-info.shinyapps.io/dashboard-hkdistrictcouncillors/), and view our GitHub repository [here](https://github.com/avisionh/dashboard-hkdistrictcouncillors).

Whether you are more of an R enthusiast or simply someone who has an interest in Hong Kong politics (hopefully both!), we hope this post will bring you some inspiration on how you can use R _not just_ as a great tool for data analysis, but also as an enabler for you to do something tangible for your community and contribute to causes you care about. 

## Background

- There are heightened levels of political engagement in Hong Kong in the recent years, which is leading to a surge in demand for information and knowledge about how people can make a difference. 
- The District Council is the most local level of government in which people can influence change.
- Who we are
- Avision Ho, a data scientist whom I had [previously interviewed.](https://martinctc.github.io/blog/data-chats-an-interview-with-avision-ho/)
- This project is an attempt to help make a difference with R programming. It's an opportunity for us to learn, to code, to have fun, and to make a difference.

## The App

<Describe the layout of the app>

## Data Collection and Cleaning
<Insert screenshot>
- Where the data came from
- Deliberated to using Google Sheets to avoid bulking up the repo, and also enable participation from those who do not code

## A solution for getting the Facebook feed
<Insert screenshot>
- Talk about challenges of getting the Facebook API
- Found a workaround using just iframes - expedient but fit-for-purpose

## Interactive Map

<Insert screenshot>
- Talk about how we started off dealing with Shape files and a ggplot map, then moved to leaflet
- Challenges and learnings

## How you can get involved
- Be a 'reveiwer' or help with coding
- Send an email to hkdistricts.info@gmail.com

