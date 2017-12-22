library('ShRoud')

infobox <- function(meta, ...){
  load_package("htmltools")
  foo <- tags$table(class="infoboxtable table table-striped", tags$tbody(), tags$tfoot(...))
  for(i in 1:length(meta)){
    foo$children[[1]]$children[[i]] <- tags$tr(
      tags$td(tags$b(names(meta)[[i]])), tags$td(meta[[i]])
    )
  }
  tags$div(class="infobox", foo)
}

get_file <- function(path, url){
  if(!dir.exists("data-cache")){
    dir.create("data-cache")
  }
  if(!file.exists(paste0("data-cache/", path))){
    download.file(url, paste0("data-cache/", path))
  }
  readFile(paste0("data-cache/", path))
}
