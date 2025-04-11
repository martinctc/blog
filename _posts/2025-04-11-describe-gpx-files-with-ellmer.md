---
title: "Generate Route Titles and Descriptions from GPX Files with LLMs and {ellmer}"
author: "Martin Chan"
date: "April 11, 2025"
tags: rstats LLMs GenAI GPX
layout: post
image: https://raw.githubusercontent.com/martinctc/blog/master/images/gpxtoolbox/ellmer-gpx.jpg
---

## Introduction

As someone who enjoys both cycling and coding in R, I've always wondered whether there are ways in which R (or data science more generally) could enhance training efficiency or the cycling experience. In the previous two posts in this blog, I wrote about using LLMs from [LM Studio](https://martinctc.github.io/blog/summarising-top-100-uk-climbs-running-local-language-models-with-lm-studio-and-r/) and [Azure](https://martinctc.github.io/blog/harness-azure-openai-and-r-summarisation-rvest/) to create text summaries and descriptions of the top 100 cycling climbs in the UK. As a sport that places heavy emphasis on data, there are actually plenty of opportunities to apply data science techniques to cycling. 

A recent opportunity for me is around the problem of planning cycle routes. Cycling routes are commonly stored in files with the extension `.gpx` (which stands for GPS Exchange Format), and they typically contain GPS data such as waypoints, routes, and tracks. GPX files are based on XML (Extensible Markup Language), meaning they use XML syntax to structure the data, making them both human-readable and machine-readable. 

Each GPX file would represent a particular cycling route, and at a certain point, one would easily have accumulated over a hundred GPX files without a system to organise them. For instance,

* how would I figure out the distance and elevation of each route? 
* is the route a loop, or is it a one-way route? 
* where does the route go through? 

The traditional way to figure this out is to manually load the GPX file into your route planner of choice, be it Strava, Komoot, Garmin, Hammerhead, etc., and again _manually_ give the route a title and a description. It's probably going to take 5 minutes to do this for each route - give or take - but why spend your time doing things manually when you can spend more time on the bike, right? 😊

With **a lot** of help from GitHub Copilot (so much so that I have to credit it here), I created the [`gpxtoolbox`](https://github.com/martinchan/gpxtoolbox) package, which allows you to read in GPX files programmatically into R, and:

* Generate route maps and elevation profile graphs
* Calculate total distance and elevation statistics
* Identify locations at the start and end points of the route, as well as the 25%, 50%, and 75% marks 
* Interface with LLMs with {ellmer} to generate a title and description of the GPX file. 

What this essentially means is that there is now an R workflow to get from a GPX file (or hundreds of them) to an LLM-generated title and description for the route. Since {ellmer} allows you to interface with LLMs like OpenAI, Azure OpenAI, Claude, Gemini, and more, you can also play with the model options as well as the prompt to optimise the results. 

This post will provide an introduction to {gpxtoolbox} and how to use it. 

## Getting Started

To follow along, you'll need the following:

- The `{gpxtoolbox}` package for processing GPX files.
- The `{ellmer}` package for interfacing with LLMs.
- An API key for your chosen LLM provider (e.g., OpenAI, Azure OpenAI).

Let's start by installing the required packages:

```r
install.packages("ellmer")
devtools::install_github("martinchan/gpxtoolbox")
```

Since {gpxtoolbox} is not (yet) available on CRAN, the above code installs this directly from the GitHub repository. 

## Example Workflow

Here's a step-by-step guide to generating titles and descriptions for a GPX route.

### Step 1: Process a GPX File

First, use the `analyse_gpx()` function from `{gpxtoolbox}` to extract route statistics from a GPX file:

```r
library(gpxtoolbox)

# Path to the example GPX file
example_gpx_path <- system.file("extdata", "icc_intro_ride.gpx", package = "gpxtoolbox")

# Analyse the GPX file and get route statistics
stats <- analyse_gpx(example_gpx_path, return = "stats")
print(stats)
```

### Step 2: Generate a Title and Description

Next, use the `gen_description()` function to generate a title and description for the route. Specify the platform, API key, and model to use:

```r
library(ellmer)

# Generate a title and description using OpenAI
result <- gen_description(
  stats = stats,
  platform = "openai",
  api_key = Sys.getenv("OPENAI_API_KEY"),
  model = "gpt-3.5-turbo"
)

cat(result)
```

The output will include a title and a detailed description of the route, highlighting key features such as distance, elevation gain, and notable landmarks.

### Step 3: Customizing the Prompt

The `gen_description()` function uses a default prompt to generate the title and description. If you'd like to customize the output, you can modify the `desc_prompt.md` file included in the `{gpxtoolbox}` package. This allows you to tailor the tone and style of the generated text to your preferences.

## Why Use {ellmer}?

In previous posts, I've demonstrated how to create custom functions for interfacing with LLMs. While this approach offers flexibility, it can be time-consuming to maintain and adapt to different providers. The `{ellmer}` package simplifies this process by providing a consistent interface to multiple LLM platforms, including:

- OpenAI (e.g., GPT-3.5, GPT-4)
- Azure OpenAI
- Claude
- Gemini
- Perplexity
- DeepSeek

With `{ellmer}`, you can switch between providers with minimal changes to your code, making it a versatile and efficient solution for working with LLMs.

## Conclusion

The integration of `{gpxtoolbox}` and `{ellmer}` opens up exciting possibilities for automating the creation of route titles and descriptions. Whether you're a cyclist, hiker, or outdoor enthusiast, this feature can save you time and help you share your adventures in a more engaging way.

If you haven't already, give `{gpxtoolbox}` and `{ellmer}` a try and let me know what you think. Happy exploring!
