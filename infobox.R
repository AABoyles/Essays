library("htmltools")
infobox <- function(meta, ...){
  foo <- tags$table(class="infobox", tags$tbody(), tags$tfoot(...))
  for(i in 1:length(meta)){
    foo$children[[1]]$children[[i]] <- tags$tr(
      tags$td(tags$b(names(meta)[[i]])), tags$td(meta[[i]])
    )
  }
  foo
}
