---
title: "Generate Route Titles and Descriptions from GPX Files with LLMs and {ellmer}"
author: "Martin Chan"
date: "April 11, 2025"
tags: rstats LLMs GenAI gpx
layout: post
image: https://raw.githubusercontent.com/martinctc/blog/master/images/gpxtoolbox/cyclist-planning-route.png
---

## Introduction

![](https://raw.githubusercontent.com/martinctc/blog/master/images/gpxtoolbox/cyclist-planning-route.png)

As someone who enjoys both cycling and coding in R, I've always wondered whether there are ways in which R (or data science more generally) could help with my training efficiency or the cycling experience. In the previous two posts in this blog, I wrote about using LLMs from [LM Studio](https://martinctc.github.io/blog/summarising-top-100-uk-climbs-running-local-language-models-with-lm-studio-and-r/) and [Azure OpenAI](https://martinctc.github.io/blog/harness-azure-openai-and-r-summarisation-rvest/) to create text summaries and descriptions of the top 100 cycling climbs in the UK. As a sport that places heavy emphasis on data, there are actually plenty of opportunities to apply data science techniques to cycling. 

A recent opportunity for me is around the problem of planning cycle routes. Cycling routes are commonly stored in files with the extension `.gpx` (which stands for GPS Exchange Format), and they typically contain GPS data such as waypoints, routes, and tracks. GPX files are based on XML (Extensible Markup Language), meaning they use XML syntax to structure the data, making them both human-readable and machine-readable. 

Each GPX file would represent a particular cycling route, and at a certain point, one would easily have accumulated over a hundred GPX files without a system to organise them. This poses a problem. For instance,

* how would I figure out the distance and elevation of each route? 
* is the route a loop, or is it a one-way route? 
* where does the route go through? 

The traditional way to figure this out is to manually load the GPX file into your route planner of choice, be it Strava, Komoot, Garmin, Hammerhead, etc., and again _manually_ give the route a title and a description. It's probably going to take 5 minutes to do this for each route - give or take - but why spend your time doing things manually when you can spend more time on the bike, right? 😊

With **a lot** of help from GitHub Copilot (so much so that I have to credit it here), I created the [`gpxtoolbox`](https://github.com/martinctc/gpxtoolbox) package, which allows you to read in GPX files programmatically into R, and:

* Generate route maps and elevation profile graphs
* Calculate total distance and elevation statistics
* Identify locations at the start and end points of the route, as well as the 25%, 50%, and 75% marks 
* Interface with LLMs with [{ellmer}](https://ellmer.tidyverse.org/) to generate a title and description of the GPX file. The `{ellmer}` package provides a unified and consistent interface to interact with multiple large language model (LLM) providers, such as OpenAI, Azure OpenAI, Claude, and Gemini.

What this essentially means is that there is now an R workflow to get from a GPX file (or hundreds of them) to an LLM-generated title and description for the route. Since {ellmer} allows you to interface with different LLMs, you can also play with the model options as well as the prompt to optimise the results. 

This post will provide an introduction to {gpxtoolbox} and how to use it. 

## Getting Started

To follow along, you'll need the following:

- The `{gpxtoolbox}` package for processing GPX files.
- The `{ellmer}` package for interfacing with LLMs.
- An API key for your chosen LLM provider (e.g., OpenAI, Azure OpenAI).

Let's start by installing the required packages:

```r
install.packages("ellmer")
devtools::install_github("martinctc/gpxtoolbox")
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

The following is returned:
```
$total_distance_km
[1] 42.81

$total_elevation_gain_m
[1] 622.2

$total_elevation_loss_m
[1] 556.6

$max_elevation_m
[1] 143

$min_elevation_m
[1] 29.9

$start_point
[1] "The Gatehouse, Fieldway Crescent, Canonbury, Highbury, London Borough of Islington, London, Greater London, England, N5 1PZ, United Kingdom"

$end_point
[1] "Archway Road, London Borough of Haringey, London, Greater London, England, N6 4EJ, United Kingdom"

$p25_point
[1] "Highwood Hill, Mill Hill, London Borough of Barnet, London, Greater London, England, NW7 4HN, United Kingdom"

$p50_point
[1] "36, Camlet Way, Hadley Wood, London Borough of Enfield, London, Greater London, England, EN4 0LJ, United Kingdom"

$p75_point
[1] "Lincoln Road, Colney Hatch, London Borough of Barnet, London, Greater London, England, N2 9DJ, United Kingdom"
```

In the above example, `example_gpx_path` points to a sample GPX file that comes installed with the {gpxtoolbox} package, which is a route for the introduction ride for the Islington Cycling Club. You can replace `example_gpx_path` with the path to a GPX file that you have saved locally to your machine. Alternatively, you can also supply an URL to a route on [Ride with GPS](https://ridewithgps.com/).

The `stats` object is a named list containing key metrics and details about the GPX route:

- **`$total_distance_km`**: The total distance of the route in kilometers.
- **`$total_elevation_gain_m`**: The total elevation gain (uphill) in meters.
- **`$total_elevation_loss_m`**: The total elevation loss (downhill) in meters.
- **`$max_elevation_m`**: The highest elevation point along the route in meters.
- **`$min_elevation_m`**: The lowest elevation point along the route in meters.
- **`$start_point`**: A human-readable address or location for the starting point of the route.
- **`$end_point`**: A human-readable address or location for the ending point of the route.
- **`$p25_point`, `$p50_point`, `$p75_point`**: Human-readable addresses or locations for the points at 25%, 50%, and 75% of the route's total distance, respectively. In {gpxtoolbox}, this is implemented as an API call to OpenStreetMap with the latitude and longitude columns exposed in the track points. For more details, see the implementation of [`identify_geo()`](https://martinctc.github.io/gpxtoolbox/reference/identify_geo.html).


### Step 2: Generate a Title and Description

`gen_description()` accepts a list of route statistics as per above, and uses this as part of the prompt to be sent to the LLM. Note that before you can use `gen_description()`, you will need to have obtained an API key and endpoint from your LLM provider of choice. This function directly calls the `chat_*()` prefixed functions from {ellmer}, for which you can find more information [here](https://ellmer.tidyverse.org/reference/index.html). For instance, you would need to satisfy the arguments from `chat_azure()` if you are using Azure AI, `chat_claude()` for Claude, and so on. For an example on how to set up Azure Open AI, you can reference [this previous post](https://martinctc.github.io/blog/harness-azure-openai-and-r-summarisation-rvest/).

Once you have all the bits and pieces ready, simply pass the list object containing the route stats and the required API values to `gen_description()`, using the `platform` argument to specify the platform to use (which in turn determines which function to call from {ellmer}): 

```r
# Generate a title and description using OpenAI
result <- gen_description(
  stats = stats,
  platform = "azure",
  api_key = Sys.getenv("OPENAI_API_KEY"),
  deployment_id = "gpt-4o-mini"
)

cat(result)
```

The output will include a title and a detailed description of the route, highlighting key features such as distance, elevation gain, and notable landmarks:

```r
[1] "**Title:** Highbury to Highwood Hill Adventure - 42.8 km, 622 m Climb  \n\n**Description:** Embark on an exhilarating journey from The Gatehouse in Canonbury to Archway Road, traversing through the scenic landscapes of North London. This 42.81 km route offers a total elevation gain of 622.2 m, showcasing a mix of rewarding climbs and gentle descents. Experience stunning views at the 25% mark at Highwood Hill in Mill Hill, pass through the tranquil Camlet Way at the halfway point, and enjoy the charm of Lincoln Road in Colney Hatch as you approach the final stretch. With elevations ranging from 29.9 m to a peak of 143 m, this route is perfect for those looking to experience both urban and lush green environments in a single adventure. Lace up your hiking boots and explore the diverse terrains this route has to offer!"
```

### Step 3: Customizing the Prompt

The `gen_description()` function uses a default prompt to generate the title and description. If you'd like to tailor the output, you can use the `prompt` argument to supply your own prompt to the function. The template prompt, which is used as default, is stored in `desc_prompt.md` file included in the `{gpxtoolbox}` package. This allows you to tailor the tone and style of the generated text to your preferences.

### Step 4: Visualizing the route

Asides from generating a title and description for a route, you can also visualise the route with `plot_route()`, which generates the shape of the route and the elevation profile. Admittedly, this feature is not as developed as I would like, and I am considering to integrate {leaflet} or some sort of mapping package as a next step. You can check out [this vignette](https://martinctc.github.io/gpxtoolbox/articles/gpxtoolbox.html) which I will update with examples as new features land. 


## Why Use {ellmer}?

In previous posts, I've demonstrated how to create custom functions for interfacing with LLMs. While this approach offers flexibility, it can be time-consuming to maintain and adapt to different providers. The `{ellmer}` package simplifies this process by providing a consistent interface to multiple LLM platforms, including:

- OpenAI
- Azure OpenAI
- Claude
- Gemini
- Perplexity
- DeepSeek

With `{ellmer}`, you can switch between providers with minimal changes to your code, making it a versatile and efficient solution for working with LLMs.

## Conclusion

The integration of `{gpxtoolbox}` and `{ellmer}` opens up many possibilities for automating the creation of route titles and descriptions. Whilst this tool was originally inspired by a cycling use case, this package is relevant also for planning hikes, walks, or runs. If you haven't already, give `{gpxtoolbox}` and `{ellmer}` a try and let me know what you think. Happy exploring!

N.B. For any enhancement or bug requests, I would appreciate if you can submit an issue to <https://github.com/martinctc/gpxtoolbox/issues>. Thank you!
