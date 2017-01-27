library("htmltools")
infobox <- function(meta, ...){
  foo <- tags$table(class="infoboxtable", tags$tbody(), tags$tfoot(...))
  for(i in 1:length(meta)){
    foo$children[[1]]$children[[i]] <- tags$tr(
      tags$td(tags$b(names(meta)[[i]])), tags$td(meta[[i]])
    )
  }
  tags$div(class="infobox", foo)
}

getFile <- function(path, url){
  if(!dir.exists("data-cache")){
    dir.create("data-cache")
  }
  if(!file.exists(paste0("data-cache/", path))){
    download.file(url, paste0("data-cache/", path))
  }
  readFile(paste0("data-cache/", path))
}

# Borrowed from the Functional Package, which had misnamed it "Curry"
PartialApp <- function(FUN,...) {
  .orig = list(...);
  function(...) do.call(FUN,c(.orig,list(...)))
}

getExtension <- function(filename){
  if(!is.character(filename)){
    filename <- toString(filename)
  }
  parsed <- strsplit(filename, ".", TRUE)[[1]]
  num    <- length(parsed)
  return(tolower(parsed[num]))
}

readFile <- function(path){
  errorframe <- data.frame(error="I don't understand this Dataset", extension=extension, path=path)
  # This insane this is designed to reduce the number of dependencies while maintaining a workflow that "just works"
  # The tradeoff is that it may behave differently on systems with different sets of packages.
  # TODO: think through how to do this properly, if possible.
  if(! "readr" %in% installed.packages()){
    read_csv <- PartialApp(read.csv, stringsAsFactors = FALSE)
    read_tsv <- PartialApp(read.table, stringsAsFactors = FALSE, sep = "\t")
    read_table <- PartialApp(read.table, stringsAsFactors = FALSE)
  }
  if(! "haven" %in% installed.packages()){
    read_dta <- foreign::read.dta
    read_spss <- foreign::read.spss
    read_sas <- function(...){errorframe}
  }
  if(! "readxl" %in% installed.packages()){
    read_excel <- function(...){errorframe}
  }
  switch(getExtension(path),
    arff     = return(foreign::read.arff(path)),
    csv      = return(read_csv(path)),
    dat      = return(read_table(path)),
    dbf      = return(foreign::read.dbf(path)),
    dta      = return(read_dta(path)),
    fwf      = return(read_table(path)),
    sasb7dat = return(read_sas(path)),
    sav      = return(read_sav(path)),
    spss     = return(read_spss(path)),
    tsv      = return(read_tsv(path)),
    txt      = return(read_table(path)),
    xls      = return(read_excel(path)),
    xlsx     = return(read_excel(path)),
    return(errorframe)
  )
}
