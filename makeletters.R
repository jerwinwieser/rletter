
details <- read.csv2("details.csv", stringsAsFactors = F)
detailscase <- details[1,]

create_dirs <- function(x="lettertest/") {
  x <- paste0("output/",x)
  if (!file.exists(x)){
    print(paste0('creating the dir ', x))
    dir.create(x)
    file.copy(from = "template/letter.tex", to = paste0(x,"/letter.tex"), overwrite = T)
  } else {
    print(paste0('dir ', x, 'already exists, but copying the directory anyway for now, poissbly overwriting the files in it..'))
    file.copy(from = "template/letter.tex", to = paste0(x,"/letter.tex"), overwrite = T)
  }
}

company <- detailscase$companynameshort
create_dirs(x=company)

compose_letter <- function(x) {
  filename <- paste0("output/", x$companynameshort, "/letter.tex")
  fileconnection <- file(filename)
  content <- readLines(filename)
  contentadj <- content
  for (i in ncol(details)) {
    var <- names(details)[i]
    pattern <- paste0('\\newcommand{\\', var, '}{', var, '}')
    replacement <- paste0("\\newcommand{\\", var, "}{", details[i], "}")
    contentadj <- gsub(pattern, replacement, contentadj, fixed = T, perl = F)
  }
  writeLines(contentadj, fileconnection)
  close(fileconnection)
}

compose_letter(x=detailscase)
