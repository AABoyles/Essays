infobox <- function(meta, ...){
  library("htmltools")
  foo <- htmltools::tags$table(class="infoboxtable table table-striped", htmltools::tags$tbody(), htmltools::tags$tfoot(...))
  for(i in 1:length(meta)){
    foo$children[[1]]$children[[i]] <- htmltools::tags$tr(
      htmltools::tags$td(htmltools::tags$b(names(meta)[[i]])), htmltools::tags$td(meta[[i]])
    )
  }
  htmltools::tags$div(class="infobox", foo)
}
