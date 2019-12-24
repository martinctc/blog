# Vignette: Downloadable tables in RMarkdown with DT

## Background

In one of my earlier posts this year, I discussed using [flexdashboard](https://martinctc.github.io/blog/my-favourite-alternative-to-excel-dashboards/) (with **RMarkdown**) as an appealing and practical R alternative to Excel-based reporting dashboards. Since it's possible to (i) export these 'flexdashboards' as static HTML files that can be opened on practically any computer (virtually no dependencies), (ii) shared as attachments over emails, and (iii) run without relying on servers and Internet access, they rival 'traditional' Excel dashboards on _portability_. This is an advantage that you don't really get with other dashboarding solutions such as Tableau and **Shiny**, as far as I'm aware. 

Traditionally, people also like Excel dashboards for another reason, which is that all the data that is reported in the dashboard is usually _self-contained_ and available in the Excel file in itself (provided that the source data within Excel isn't hidden and protected). This enables any keen user to extract the source data to produce charts or analysis on their own "off-dashboard". Moreover, having the data available within the dashboard itself helps with _reproducibility_, in the sense that one can more easily trace back the relationship between the source data and the reported analysis or visualisation. 

![](https://raw.githubusercontent.com/martinctc/blog/master/images/dashboard-excel-flexdashboard-meme.jpg)

In this post, I am going to share a trick on how to implement this feature within **RMarkdown** (and therefore means you can do this in **flexdashboard**) such that the users of your dashboards can export/download your source data. This will be implemented using the [DT](https://rstudio.github.io/DT/) package created by [RStudio](https://rstudio.com/), which provides an R interface to the JavaScript library [DataTables](https://datatables.net/).[^1] 

(Credits to [Jonathan Ng](https://datastrategywithjonathan.com/) for sharing this trick with me in the first place! His original video tutorial that first mentions this is available [here](https://www.youtube.com/watch?v=ux2tQqgY8Gg))

## The DT package

In a nutshell, [DT](https://github.com/rstudio/DT) is a R package that enables you to create interactive, pretty HTML tables with fancy features such as filter, search, scroll, pagination, and sort - to name a few. Since **DT** generates a [html widget](https://www.htmlwidgets.org/showcase_leaflet.html) (e.g. just like what **leaflet**, **rbokeh**, and **plotly** do), it can be used with RMarkdown HTML outputs and Shiny dashboards. I've personally found **DT** very useful when creating RMarkdown documents (knitted to HTML) because it allows you to create professional-looking, business-ready interactive tables with literally only a couple of lines of code, and you can do this entirely in R without knowing any JavaScript. The other alternative packages that perform a similar job of producing quick and pretty HTML tables are [formattable](https://github.com/renkun-ken/formattable), `knitr::kable()` and [kableExtra](https://github.com/haozhu233/kableExtra), but as far as I'm aware only **DT** allows you to add these 'data download' buttons that we are focussing on in this post. 

## Downloadable tables

What we are trying to get to is an interactive table with buttons that allow you to perform the following actions:

- Copy to clipboard
- Export to CSV
- Export to Excel
- Export to PDF
- Print

Though you might only require only one or two of the above buttons, I'm going to go through an example that lets you do all five at the same time. The below is what the final output looks like, using the `iris` dataset, where the download options are shown at the top of the widget:

![](https://raw.githubusercontent.com/martinctc/blog/master/images/dt-downloadable.PNG)

Here is an example of this widget as a **RMarkdown** html output: https://martinctc.github.io/blog/examples/dt-download-example.html

## The Solution

The main function from **DT** to create the interactive table is `DT::datatable()`. The first argument accepts a data frame, so this makes it easy to use it with **dplyr** / **magrittr** pipes. This is how we will create the above table, using the inbuilt `iris` dataset:

```r
library(tidyverse)
library(DT)

iris %>%
  datatable(extensions = 'Buttons',
            options = list(dom = 'Blfrtip',
                           buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                           lengthMenu = list(c(10,25,50,-1),
                                             c(10,25,50,"All"))))
```

And here is a brief explanation for each of the arguments used in the above code:

- **extensions**: this takes in a character vector of the names of [DataTables plug-ins](https://rstudio.github.io/DT/plugins.html), but only plugins supported by the DT package can be used here. We'll just put 'Buttons' here.

- **options**: this argument is where you feed in all the additional customisation options, which is specified in a list.[^2] I usually think of these as 'expanded features' that aren't / haven't been built into the **DT** package yet, but are available in the 'source' JavaScript library **DataTables**.

  - **dom**: This argument defines the table control elements to appear on the page and in what order. Here, we have specified this to be `Blfrtip`, where: 

    - `B` stands for **b**uttons,

    -  `l` for **l**ength changing input control,

    -  `f` for **f**iltering input,

    -  `r` for p**r**ocessing display element,

    -  `t` for the **t**able,

    -  `i` for table **i**nformation summary,

    -  and finally, `p` for **p**agination display. 

      You may move the letters around to control for where the buttons are placed, where for instance `lfrtipB` would place the buttons at the very bottom of the widget.

  - **buttons**: you pass a character vector through to specify what buttons to actually display in the widget, where 'copy' stands for copy to clipboard, 'csv' stands for 'export to csv', etc. 

  - **lengthMenu**: this allows you to specify display options for how many rows of data to display on each page. Here, I've passed a list through with two vectors, where the first specifies the page length values and the second the displayed options.
  

Try it out! Note that if you run this code in a R script, the table will open up in your Viewer Pane in RStudio, but you will need to run the code within a **RMarkdown** document in order to produce a share-able HTML output. 

## Create a function (for cleaner code)

I've wrapped the solution in a handy function called `create_dt()`, which just adds a bit of convenience as I can simply load this script at the beginning of a RMarkdown document and then call the function throughout the document, whenever I want to display the data and make them downloadable. Here it is:

```r
create_dt <- function(x){
  DT::datatable(x,
                extensions = 'Buttons',
                options = list(dom = 'Blfrtip',
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                               lengthMenu = list(c(10,25,50,-1),
                                                 c(10,25,50,"All"))))
}
```

You can customise this function to suit whatever needs you have for your project, but I find creating a function for the task of generating **DT** tables just makes the overall code cleaner, shorter, and easier to follow.

## End notes

Hope you enjoyed this short vignette. 

Do comment down below if you find this useful, or if you have any related ideas or suggestions you'd like to share. If you liked this post, please do check out my [blog](https://martinctc.github.io/blog/) for more R and data science related content. 

And have a Merry Christmas everyone!

[^1]: Not to be confused with the [data.table](https://github.com/Rdatatable/data.table) package, which is practically a "super" package for [fast data manipulation and wrangling](https://martinctc.github.io/blog/using-data.table-with-magrittr-pipes-best-of-both-worlds/).
[^2]: See https://datatables.net/reference/option/ for a full documentation of the options.