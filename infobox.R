load_package <- function(package, repos = "https://cloud.r-project.org/"){
  tryCatch(typeof(package), error = function(e){ package = deparse(substitute(package)) })
  if(! package %in% .packages(all = TRUE)){
    install.packages(package, repos = repos)
  }
  library(package, character.only = TRUE)
}

load_packages <- function(packages){
  map(packages, load_package)
}

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

# Borrowed from the Functional Package, which had misnamed it "Curry"
partial_apply <- function(FUN,...) {
  .orig = list(...);
  function(...) do.call(FUN,c(.orig,list(...)))
}

get_extension <- function(filename){
  if(!is.character(filename)){
    filename <- toString(filename)
  }
  parsed <- strsplit(filename, ".", TRUE)[[1]]
  num    <- length(parsed)
  return(tolower(parsed[num]))
}

# This insane thing is designed to reduce the number of dependencies while maintaining a workflow 
# that "just works". The tradeoff is that it may behave differently on systems with different sets
# of packages.
# TODO: think through how to do this properly, if possible.
read_file <- function(path, ...){
  fail <- function(){ stop("This R session doesn't have a parser for this filetype.") }
  extension <- get_extension(path)
  if(extension == "arff"){ return(foreign::read.arff(path, ...)) }
  if(extension == "csv"){
    if("readr" %in% .packages(all = TRUE)){
      load_package("readr")
    } else {
      read_csv <- partial_apply(read.csv, stringsAsFactors = FALSE)
    }
    return(read_csv(path, ...))
  }
  if(extension %in% c("dat", "fwf", "txt")){
    if("readr" %in% .packages(all = TRUE)){
      load_package("readr")
    } else {
      read_table <- partial_apply(read.table, stringsAsFactors = FALSE)
    }
    return(read_table(path, ...))
  }
  if(extension == "dbf"){ return(foreign::read.dbf(path, ...)) }
  if(extension == "dta"){
    if("haven" %in% .packages(all = TRUE)){
      load_package("haven")
    } else {
      read_dta <- foreign::read.dta
    }
    read_dta(path, ...)
  }
  if(extension == "sasb7dat"){
    load_package("haven")
    return(read_sas(path, ...))
  }
  if(extension == "por"){
    if("haven" %in% .packages(all = TRUE)){
      load_package("haven")
    } else {
      read_por <- foreign::read.spss
    }
    return(read_por(path, ...))
  }
  if(extension == "sav"){
    if("haven" %in% .packages(all = TRUE)){
      load_package("haven")
    } else {
      read_sav <- foreign::read.spss
    }
    return(read_sav(path, ...))
  }
  if(extension == "spss"){
    if("haven" %in% .packages(all = TRUE)){
      load_package("haven")
    } else {
      read_spss <- foreign::read.spss
    }
    return(read_spss(path, ...))
  }
  if(extension == "tsv"){
    if("readr" %in% .packages(all = TRUE)){
      load_package("readr")
    } else {
      read_tsv <- partial_apply(read.table, stringsAsFactors = FALSE, sep = "\t")
    }
    return(read_tsv(path, ...))
  }
  if(extension %in% c("xls", "xlsx")){
    load_package("readxl")
    return(read_excel(path, ...))
  }
  fail()
}
