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

## Jekyll and Ruby

To run the site locally, [jekyll](https://jekyllrb.com/docs/) is required, which in turn requires installing [Ruby](https://www.ruby-lang.org/en/downloads/). 

Once **Ruby** and **gem** is installed, you can run this to install jekyll and other bundler gems: 
```cmd
gem install jekyll bundler
gem install jekyll-sitemap 
gem install jekyll-feed
```

Once everything is installed, run `jekyll serve` in the blog root directory. The console should show a link like 'http://127.0.0.1:4000/blog' for you to run on your browser. 


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

## Repo structure

* `_posts` contains the final markdown files that are used for creating the blog. These are initially rendered by prettyjekyll, but may be edited manually to address issues with the original rendering.
* `_knitr` contains the initial RMarkdown files used for drafting the blog posts, and for generating the required markdown files. 
* Other files in the repo are either layout files for the blog, or static resources (such as images) used in the blog posts.

## Tags

* To add a tag to a post, update the markdown files in `_posts` directly. 
* To add a _new_ tag category, be sure to add a new markdown file under `blog/tag/`, following the layout and naming convention of the other files to match the tag name. This will make sure that a tagpage will be generated for the new tag category.