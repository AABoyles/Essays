get_file <- function(path, url){
  if(!dir.exists("data-cache")){
    dir.create("data-cache")
  }
  if(!file.exists(paste0("data-cache/", path))){
    download.file(url, paste0("data-cache/", path))
  }
  readFile(paste0("data-cache/", path))
}
