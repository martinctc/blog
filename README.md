## Implementation

See [privefl's Jekyll Now](https://github.com/privefl/jekyll-now-r-template) template and Barry Clark's [Jekyll Now](https://github.com/barryclark/jekyll-now).

This blog is built using a combination of:
- RMarkdown
- Jekyll (GitHub Pages generated)
- the {prettyjekyll} package

The static site is generated with Jekyll via GitHub Pages, rather than locally.

## Publishing

Posts from this blog can be found on:
- r-bloggers
- RWeekly.org

## Notes on {prettyjekyll}

Requirements and features of FormatPost
---------------------------------------

- Install package {prettyjekyll} using `devtools::install_github("privefl/prettyjekyll")`.

- The yaml header (delimited by '---') of you Rmd file needs to contain a title and a date.

- Function `prettyjekyll::FormatPost()`

    - renders your R Markdown as an HTML Pretty Document,
    
    - gets the main content of this HTML Pretty Document to put it in a new Markdown post that is rendered with Jekyll,
    
    - creates the name of the markdown file with the date and the title of your post,
    
    - makes some changes in figures' and images' paths to be recognized in the site. 
    
You can keep the default path to figures rendered by knitr. Caching is now supported starting with version 0.2.3. You should directly use the R Markdown template from this package.