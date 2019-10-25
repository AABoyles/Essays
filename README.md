---
title: Meta
---

This repository contains my collected essays. It is also a partly self-contained build system for them, using RMarkdown.

## How can I use it?

There are [much more powerful website builders in R](https://bookdown.org/yihui/blogdown/) nowadays. Accordingly, I wouldn't recommend using this one.

If you want to build a website based off of this one, just clone the respository and remove all of the html files, along with all the Rmd files EXCEPT for index.Rmd. Then add your own collection of R Markdown documents (or plain markdown documents). Set the contents of the header menu in `_site.yml`. And then all you need to do is:


```r
library("rmarkdown")
render_site()
render_site("portfolio")
render_site("essays")
```

RMarkdown will assemble the site, and it's ready to go to Github Pages, S3, or whatever other simple file-storage server you like.

## Why did you build this?

I wanted:

1. all of my writings to live in a single, canonical location
2. all of my writings in source control
3. writings I'm willing to share publicly to be shareable
4. shareable writings on a simple, static-file server (no Wordpress)

There are a lot of ways I could have gone about it. The sort of obvious choice is jekyll, but I've never really cared for it. A friend of mine dreamed up another blog-aware static-site generator geared toward data scientists called [Lark](https://github.com/chrismeserole/lark), which is very promising. But I realized that I don't really want a blog. I don't want to bang out posts fast enough that three people care enough to visit my site once a week. I want to endlessly tinker with essays.
